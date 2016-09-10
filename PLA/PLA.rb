require 'matrix'

def sign(num)
	if num>0
		return 1.to_f
	else
		return -1.to_f
	end
end

w = Vector[0,0,0,0,0]
seq = 0
update = 0
while 1
	File.foreach("hw1_15_train.dat") do |line|
		x1, x2, x3, x4, y = line.split(' ')
		#print "y is ", y, "y tof is ", y.to_f, "\n"
		xt = Vector[1.to_f,x1.to_f,x2.to_f,x3.to_f,x4.to_f]
		if y.to_f != sign(w.inner_product xt)
			update = update+1
			print "Update= ", update, " seq= ", seq, "\n"
			w.each { |number| number.to_f }
			w = w + (xt*(y.to_f))
			print w, "\n"
		end
		seq = seq+1
		#print x1
	end
end
