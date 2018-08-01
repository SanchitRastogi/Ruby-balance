class ApplicationController < ActionController::Base

	def get_balances(address)
		limiter = 0
		max_retries = 10
		bal = []
		begin
			contract = $web3.eth.contract(ERC20_ABI)
			TOKENS.each do |token|
				t = contract.at(token[:address])
				balance = "#{t.balanceOf(address)}"
				bal << { address: address, ticker: token[:ticker], balance: balance }
			end
		rescue
			limiter += 1
			if limiter <= max_retries
				puts "AAAAAAAAAAAAAAAaaaaAAAAAAAAAAAAAA"
				retry
			else
				puts "BBBBBBBBBBBBBBBbbbbBBBBBBBBBBBBBBB"
				TOKENS.each do |token|
					bal << { address: address, ticker: token[:ticker], balance: "null" }
				end
			end
		end
		return bal
	end

	def get_wallet_addresses()
		wallet_addresses = []
		File.open("ether_wallets.txt", "r") do |file|
			file.each_line do |line|
				add = line.split(', ')				
				add.each do |a|
					if a[0] == '['
						wallet_addresses.push(a.from(2).to(-2))
					elsif a[-1] == ']'
						wallet_addresses.push(a.from(1).to(-3))
					else	
						wallet_addresses.push(a.from(1).to(-2))
					end
				end
			end
		end
		#puts wallet_addresses
		return wallet_addresses
	end

	def save_balance(bal_list)
		
		bal_list.each do |bal|
			bal.each do |tick|
				address = tick[:address]
				ticker = tick[:ticker]
				balance = tick[:balance]
				Balance.where( { address: address, ticker: ticker } ).first_or_create.update(balance: balance)
			end
		end
	end

	# def save_balance(bal)
	# 	address = bal[0][:address]
	# 	puts "BEFORE"
	# 	flag = Balance.where(address: address).exists?
	# 	puts "AFTER"
	# 	#binding.pry
	#   	if flag
	#   		@balance = Balance.where(address: address) 	
	# 		bal.length.times do |i|    
	# 			if @balance[i].update(bal[i])
	# 				puts "IM UPDATED"
	# 			else
	# 				puts "IM NOT UPDATED"
	# 			end
	# 		end
	#   	else
	# 		bal.length.times do |i|
	# 			puts "in else #{bal[i]}" 
	# 			@balance = Balance.new(bal[i])
	# 			if @balance.save
	# 				puts "IM SAVED"
	# 			else
	# 				puts "IM NOT SAVED"
	# 			end
	# 		end
	# 	end
	# end

end






























