require 'matrix'
require 'time'

def sign(num)
	if num>0
		return 1.to_f
	else
		return -1.to_f
	end
end

def test_error_rate(w)
	test_number = 0.to_f
	error_number = 0.to_f
	#print "Send in: ", w, "\n"
	File.foreach("hw1_18_train.dat") do |line|
		test_number = test_number+1
		x1, x2, x3, x4, y = line.split(' ')
		xt = Vector[1.to_f,x1.to_f,x2.to_f,x3.to_f,x4.to_f]
		#print "With: ", test_number, " ", xt, "\n"
		if y.to_f != sign(w.inner_product xt)
			error_number = error_number+1
		end
	end
	#print (error_number/test_number), "\n"
	return (error_number/test_number)
end

tau = 1.to_f
count = 2000.to_i
error_all = []
for i in 1..count
	w = Vector[0,0,0,0,0]
	pocket = Vector[0,0,0,0,0]
	w.each { |number| number.to_f }
	pocket.each { |number| number.to_f }
	seq = 0
	update = 0
	srand Time.now.to_i
	r = ((1000*rand).to_i) % 500
	#print r, " is the random number\n"
	while 1
		File.foreach("hw1_18_train.dat") do |line|
			r = r-1
			next if (r!=-1)
			r = ((1000*rand).to_i) % 500
			#print r, " is the random number\n"
			x1, x2, x3, x4, y = line.split(' ')
			xt = Vector[1.to_f,x1.to_f,x2.to_f,x3.to_f,x4.to_f]
			#print r, " is ", xt, "\n"
			if y.to_f != sign(w.inner_product xt)
				w = w + tau*(xt*(y.to_f))
				#print wnew, "\n"
				#print "new: ", test_error_rate(w), " old: ", test_error_rate(pocket), "\n"
				if test_error_rate(w) < test_error_rate(pocket)
					pocket = w
					#print "update: ", pocket, "\n"
				end	
				update = update+1
				#print w, "\n"
				#print "Update= ", update, " seq= ", seq, "\n"
			end
			seq = seq+1
			#print seq
			r = ((1000*rand).to_i) % 500
			#print r, " is the random number\n"
			break
		end
		if update>=50
			break
		end
	end
	#calculate each error rate
	test_number = 0.to_f
	error_number = 0.to_f
	File.foreach("hw1_18_test.dat") do |line|
		test_number = test_number+1
		x1, x2, x3, x4, y = line.split(' ')
		xt = Vector[1.to_f,x1.to_f,x2.to_f,x3.to_f,x4.to_f]
		if y.to_f != sign(pocket.inner_product xt)
			error_number = error_number+1
		end
	end
	#print error_number, " ", test_number, "\n"
	errorrate = error_number / test_number
	error_all << errorrate 
end
#print error_all
error_value = 0
error_all.each do |value|
	error_value = error_value + value
end
print error_value/count, " for trying ", i, " times\n"