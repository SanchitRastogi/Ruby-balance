module Tools
	module Contracts

		# def self.get_balances(address)
		# 	contract = $web3.eth.contract(ERC20_ABI)
		# 	puts "For Address #{address}"
		# 	puts "======================================================"
		# 	TOKENS.each do |token|
		# 		t = contract.at(token[:address])
		# 		puts "Balance of #{token[:ticker]}: #{t.balanceOf(address)}"
		# 		puts "----------------------"
		# 	end
		# end

		# def self.get_addresses()
		# 	wallet_addresses = []
			
		# 	File.open("ether_wallet.txt", "r") do |file|
		# 		file.each_line do |line|
		# 			add = line.split(', ')
					
		# 			add.each do |a|
		# 				wallet_addresses.push(a.from(1).to(-2))
		# 			end

		# 		end
		# 	end

		# 	wallet_addresses.each do |wallet_address|
		# 		get_balances(wallet_address)
		# 	end
		# end


		def self.get_balances(address)
			limiter = 0
			max_retries = 10
			begin
				contract = $web3.eth.contract(ERC20_ABI)
			rescue Exception => e
				limiter += 1
				if limiter <= max_retries
					retry
				end
			end
			puts "For Address #{address}"
			puts "======================================================"
			TOKENS.each do |token|
				t = contract.at(token[:address])
				puts "Balance of #{token[:ticker]}: #{t.balanceOf(address)}"
				puts "----------------------"

			end
		end

		def self.get_addresses()
			wallet_addresses = []
			
			File.open("ether_wallet.txt", "r") do |file|
				file.each_line do |line|
					add = line.split(', ')
					
					add.each do |a|
						wallet_addresses.push(a.from(1).to(-2))
					end
				end
			end

			threads = []
			batch = 20
			wallet_addresses.each do |wallet_address|
				threads << Thread.new do
					Rails.application.executor.wrap do
						puts "Im #{Thread.current.object_id}"
						get_balances(wallet_address)
					end
				end
				batch -= 1
				if batch == 0
					threads.each { |t| t.join }
					batch = 20
				end
			end
			threads.each { |t| t.join }
		end

	end
end



























