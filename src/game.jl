using Distances
using StatsBase


function initialize_game(𝒜, size = 3, num_initial = 9)
	Q = Dict()
	𝒮 = ones(Int64, (size, size))
	score = 0

	for _ in range(1, num_initial)
		add_random_tile!(𝒮)
	end

	for a in 𝒜
		if !haskey(Q, [𝒮, a])
			Q[𝒮, a] = 0
		end
	end
	return 𝒮, Q, score
end


function move(board, action)
	if action == 'R'
		rotated_board = board
	end
	if action == 'L'
		rotated_board = reverse(board, dims = 2)
	end
	if action == 'U'
		rotated_board = copy(reverse(board', dims = 2))
	end
	if action == 'D'
		rotated_board = board'
	end

	slided_board, score_increasement = slide_rows(rotated_board)


	if action == 'L'
		rerotated_board = reverse(slided_board, dims = 2)
	end
	if action == 'R'
		rerotated_board = slided_board
	end
	if action == 'U'
		rerotated_board = copy(reverse(slided_board, dims = 2)')
	end
	if action == 'D'
		rerotated_board = slided_board'
	end
	return rerotated_board,score_increasement

end


function calculate_rewards(board, new_board, score_increase)
	s = size(board)[1]
	reward = score_increase
	if board[1, 1] == maximum(board) || board[1, s] == maximum(board) || board[s, 1] == maximum(board) || board[s, s] == maximum(board)
		if new_board[1, 1] == maximum(new_board) || new_board[1, s] == maximum(new_board) || new_board[s, 1] == maximum(new_board) || new_board[s, s] == maximum(new_board)
			reward += 10
		else
			reward -= 100
		end
	else
		if new_board[1, 1] == maximum(new_board) || new_board[1, s] == maximum(new_board) || new_board[s, 1] == maximum(new_board) || new_board[s, s] == maximum(new_board)
			reward += 100
		end
	end
	if board == new_board
		reward -= 1000
	end
	return reward
end


function add_random_tile!(board)
	try
		empty_position = findall(x -> x == 1, board)[rand(1:end)]
		board[empty_position[1], empty_position[2]] = sample([2,4],Weights([0.9,0.1]))
	catch e
		println("Todas las celdas ocupadas")
	end
end

function slide_rows(board)
	new_board = copy(board)
	score_increasement = 0
	for (row, slice) in enumerate(eachrow(board))
		filtered_array = filter(x -> x != 1, slice)
		result = []
		i = length(filtered_array)
		while i >= 1
			if i > 1 && filtered_array[i] == filtered_array[i-1]
				pushfirst!(result, filtered_array[i] * 2)
				score_increasement += filtered_array[i] * 2
				i -= 1
			else
				pushfirst!(result, filtered_array[i])
			end
			i -= 1
		end
		# Rellenar con ceros hasta alcanzar el tamaño original del array
		while length(result) < length(slice)
			pushfirst!(result, 1)


		end

		new_board[row, :] = result
	end
	return new_board, score_increasement
end
