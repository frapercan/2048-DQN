include("src/game.jl")
include("src/learning.jl")
using Plots

###### Parameters ######
actions = ['R', 'L', 'U', 'D']
discount = 0.01
learning_rate = 1
exploration_rate = 0.00
###### ######### ######



function run(num_plays = 100, board_size = 4, initial_tiles = 2)
	max_value = []
	# Q_length = []
	board, Q_table, score = initialize_game(actions, board_size, initial_tiles)
	model = QLearning(board, actions, discount, Q_table, learning_rate, exploration_rate)
	for game in range(1, num_plays)
		while true
			new_board, Q, a = EpsilonGreedyExploration(model)
			println("game: ", game, " step: ", step, " action: ", a)
			if model.𝒮 == new_board
				println("End of game")
				break
			end
			add_random_tile!(new_board)
			model.𝒮 = new_board
			model.Q = Q
		end
		push!(max_value, maximum(model.𝒮))
		# push!(Q_length, length(model.Q))
		Q_table = model.Q
		model = QLearning(board, actions, discount, Q_table, learning_rate, exploration_rate)

	end
	
	plot!(max_value,label="resultados")
	xlabel!("partidas")
	ylabel!("ficha maxima")
	# plot!(Q_length)
end

run()


