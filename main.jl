using Distances

###### Parameters ######
actions = ['R', 'L', 'U', 'D']
discount = 0.01
Q_table = Dict()
learning_rate = 0.01
exploration_rate = 0.01
###### ######### ######


mutable struct QLearning
	𝒮::Any # state space (assumes 1:nstates)
	𝒜::Any # action space (assumes 1:nactions)
	γ::Any # discount
	Q::Any # action value function
	α::Any # learning rate
	ε::Any # Exploration rate
end

function lookahead(model::QLearning, s, a)
	return model.Q[s, a]
end

function update!(model::QLearning, s, a, r, s′)
	γ, Q, α = model.γ, model.Q, model.α
	Q[s, a] += α * (r + γ * maximum(Q[s′, :]) - Q[s, a])
	update!(model, s, a, r, s′)
	return model
end

function initialize_game(size = 3)
	𝒮 = ones(Int64, (size, size))

	location_one = [rand(1:size), rand(1:size)]
	location_two = [rand(1:size), rand(1:size)]
	while location_one == location_two
		location_two = [rand(1:size), rand(1:size)]
	end
	𝒮[location_one[1], location_one[2]] = Bool(rand(0:1)) ? Int64(2) : Int64(4)
	𝒮[location_two[1], location_two[2]] = Bool(rand(0:1)) ? Int64(2) : Int64(4)
	return 𝒮
end



function slide_rows(board)
	new_board = copy(board)
	for (row,slice) in enumerate(eachrow(board))
		filtered_array = filter(x -> x != 1, slice)
		result = []
		i = length(filtered_array)
		while i >= 1
			if i > 1 && filtered_array[i] == filtered_array[i - 1]
				pushfirst!(result, filtered_array[i] * 2)
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

		new_board[row,:] = result
	end
	return new_board
end


function calculate_rewards(board,new_board)
	return euclidean(board,new_board)

end

function move(board, action, return_rewards = true)
	if action == 'L'
		rotated_board = reverse(board,dims=2)
	end
	if action == 'U'
		rotated_board = copy(reverse(board',dims=2))
	end
	if action == 'D'
		rotated_board = board'
	end


	slided_board = slide_rows(board)

	if action == 'L'
		rerotated_board = reverse(slided_board,dims=2)
	end
	if action == 'U'
		rerotated_board = copy(reverse(slided_board,dims=2)')
	end
	if action == 'D'
		rerotated_board = slided_board'
	end
	display(board)
	display(rerotated_board)

	rewards = calculate_rewards(board,rerotated_board)

	print(rewards)

	if return_rewards
		return rerotated_board, rewards
	end
end






board = initialize_game(4)

move(board,'L')






model = QLearning(board,actions,discount,Q_table,learning_rate,exploration_rate)
function run(model)
	while max(board) != 2048
		action = lookahead(model.board,model.exploration_rate)

		break
	end

end