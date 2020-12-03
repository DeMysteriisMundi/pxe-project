#!/usr/bin/env bash


read_cfg() {
    # SCRIPT
    BDIR=$(dirname $(readlink -f $0))
    DDIR="$BDIR/drives"

    # VM
    MEM=4096
    CPU=2
    DSK=4
    SZE=10

    # BOOT
    BORDER='ndc'

    # NETWORK
    TAPIF='qemutap0'
    BRNAME=$(brctl show | grep -E "^br-[0-9a-z]+" -o)

    # MANAGEMENT
    VNC='1'
}


get_args() {
    case $1 in
        "start")
	    shift
    	    get_start_args "$@"
	    start_vm
        ;;

	"create")
	    shift
	    get_create_args "$@"
	    create_vm
	;;

	"--help")
            print_usage
	    exit 1
	;;

	*)
            print_usage
	    exit 1
	;;
    esac
}


get_start_args() {
    while [[ "$1" ]];
    do
        case $1 in
    	# VM
    	"--cpu") CPU="${2:-$CPU}" ;;
    	"--memory") MEM="${2:-$MEM}" ;;
    
    	# BOOT
    	"--boot-order") BORDER="${2:-$BORDER}" ;;
    
    	# NETWORK
    	"--if") TAPIF="${2:-$TAPIF}" ;;
    	"--br") BRNAME="${2:-$BRNAME}" ;;
    
    	# MANAGEMENT
    	"--novnc") VNC=0 ;;

        esac

	shift
    done
}


get_create_args() {
    while [[ "$1" ]];
    do
        case $1 in
    	"--disks") DSK="${2:-$DSK}" ;;
    	"--size") MEM="${2:-$SZE}" ;;

        esac

	shift
    done
}


print_usage() {
    printf "%s" "\
Usage: qemu-vm <start|create>
    start: start created VM 
        --cpu [num]             	        CPU amount. 			Ex. --cpu 2.
	--memory [num]               		RAM in MB. 			Ex. --memory 4096.
	--boot-order [str]			Use QEMU style. 		Ex. --boot-order 'ndc' is a network > cd-rom > disk.
	--if [str]				Interface name. 		Ex. --if qemutap0.
	--br [str]				Bridge name VM connected to. 	Ex. --br br-5412
	--novnc					VM started with VNC server. This option started VM in standard GUI.

    create: create VM
    	--disks [num]				Disks amount. 			Ex. --disks 4.
	--size [num]				Disks size in GB. 		Ex. --size 10.
"
}


net_up() {
    ip tuntap add $TAPIF mode tap
    ip link set $TAPIF up
    brctl addif $BRNAME $TAPIF
}


net_down() {
    brctl delif $BRNAME $TAPIF
    ip tuntap del $TAPIF mode tap
}


start_vm() {
    net_up

    qemu-system-x86_64 \
        -m $MEM \
        -smp $CPU \
        \
        -netdev tap,id=qemunet0,ifname=$TAPIF,script=no,downscript=no \
        -device e1000,netdev=qemunet0,mac=52:55:00:d1:55:01 \
        \
        -boot order=$BORDER \
	$(I=0; for DISK in "$DDIR"/*.img; do printf "%s\n" "-drive file=$(readlink -f $DISK),index=$I,media=disk"; I=$((I=I+1)); done) \
        \
        $([[ $VNC -eq 1 ]] && printf '%s' '-vnc :0 -monitor stdio')
    

    net_down
}


create_vm() {
    mkdir -p "$DDIR"
    for ((I=1;I<=$DSK;I++)); do
        qemu-img create -f qcow2 "$DDIR/drive$I.img" "${SZE}G";
    done
}


main() {
    read_cfg

    get_args "$@"
}


main "$@"

