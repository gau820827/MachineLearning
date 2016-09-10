require 'matrix'
require 'time'

def sign(num)
	if num>0
		return 1
	else
		return -1
	end
end

tau = 0.5.to_f
count = 2000.to_i
updateall = []
for i in 1..count
	w = Vector[0,0,0,0,0]
	seq = 0
	update = 0
	srand Time.now.to_i
	r = ((1000*rand).to_i) % 400
	rr = r
	#print r, " is the random number\n"
	check = Array.new(400)
	while 1
		File.foreach("hw1_15_train.dat") do |line|
			check[rr] = 1
			r = r-1
			next if (r!=-1)
			r = ((1000*rand).to_i) % 400
			rr = (r + rr) % 400
			r = rr
			x1, x2, x3, x4, y = line.split(' ')
			xt = Vector[1.to_f,x1.to_f,x2.to_f,x3.to_f,x4.to_f]
			if y.to_f != sign(w.inner_product xt)
				check = Array.new(400)
				update = update+1
				#print "Update= ", update, " seq= ", seq, "\n"
				w.each { |number| number.to_f }
				w = w + tau*(xt*(y.to_f))
				#print w, "\n"
			end
			seq = seq+1
			#print seq
		end
			next if check.include?(NIL)
			break
	end
	updateall << update
	#print updateall
end
updateing=0
updateall.each do |value|
	updateing = updateing + value
end
print updateing/count, " for trying ", i, " times\n"