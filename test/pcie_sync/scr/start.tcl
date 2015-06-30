database -open  waves -into waves.shm -default
probe -create testbench_pcie -depth all -all -database waves
run 500000

