database -open  waves -into waves.shm -default
probe -create tb_scramble -depth 10 -all -database waves

run 2000ns
