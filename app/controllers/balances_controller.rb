class BalancesController < ApplicationController
  def getone
  	address = params.require(:address)
  	bal = get_balances(address)
	# save_balance(bal)
	# bal = Balance.where({address: address, ticker: 'mno'}).first_or_create.update(balance: '666')
	# bal = Balance.all
  	render json: {status: 'SUCCESS', message: 'Balances done', data: bal},status: :ok
  end

  def getall 
  	wallet_addresses = get_wallet_addresses

	threads = []
	batch = 2000
	bal_list= []
	wallet_addresses.each do |wallet_address|
		threads << Thread.new do
			puts "THREAD #{Thread.current.object_id} started"
		  	bal_list << get_balances( wallet_address )
		  	puts "THREAD #{Thread.current.object_id} ended"
		end
		batch -= 1
		if batch == 0
			threads.each { |t| t.join }
			batch = 2000
		end
	end
	threads.each { |t| t.join }

	save_balance( bal_list )
	all_balance = Balance.all
	render json: {status: 'SUCCESS', message: 'Balances done', data: wallet_addresses},status: :ok
  end

end
























