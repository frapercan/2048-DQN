mutable struct QLearning
	𝒮::Any # state space (assumes 1:nstates)
	𝒜::Any # action space (assumes 1:nactions)
	γ::Any # discount
	Q::Any # action value function
	α::Any # learning rate
	ϵ::Any # Exploration rate
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

function EpsilonGreedyExploration(model)
	𝒮, 𝒜, Q, ϵ = model.𝒮, model.𝒜, model.Q, model.ϵ
	
	for a in 𝒜
		new_board, score_increasement = move(𝒮, a)
		rewards = calculate_rewards(𝒮, new_board, score_increasement)
		Q[𝒮, a] = rewards
	end

	if rand() < ϵ
		a = rand(𝒜)
	else
		a = argmax(a -> Q[𝒮, a], 𝒜)
	end

	for a in 𝒜
		println("Action: ",a, "Value: ", Q[𝒮, a])
	end

	println(" ")
	new_board, _ = move(𝒮, a)
	return new_board, Q, a
end


function initialize_Q_table_if_empty(model, board)
	for a in model.𝒜
		if !haskey(model.Q, [board, a])
			model.Q[board, a] = 0
		end
	end
	return model
end