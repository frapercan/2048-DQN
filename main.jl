mutable struct QLearning
	𝒮::Any # state space (assumes 1:nstates)
	𝒜::Any # action space (assumes 1:nactions)
	γ::Any # discount
	Q::Any # action value function
	α::Any # learning rate
end
function lookahead(model::QLearning, s, a)
    return model.Q[s, a]
end

function update!(model::QLearning, s, a, r, s′)
	γ, Q, α = model.γ, model.Q, model.α
	Q[s, a] += α * (r + γ * maximum(Q[s′, :]) - Q[s, a])
	return model
end

function initialize_game(size=3)
	𝒮 = Array{Union{Nothing, Int}}(nothing, size, size)
	
	location_one = [rand(1:size),rand(1:size)]
	location_two = [rand(1:size),rand(1:size)]
	while location_one == location_two
		location_two = [rand(1:size),rand(1:size)]
	end
	𝒮[location_one[1],location_one[2]] = Bool(rand(0:1)) ? 2 : 4
	𝒮[location_two[1],location_two[2]] = Bool(rand(0:1)) ? 2 : 4
	return 𝒮
end

function move(s,a)
	display(s)
	movements = Dict(1=>[-1,0],2=>[1,0],3=>[0,-1],3=>[0,1])
	shape = size(s)
	for i in range(1,shape[1])
		for j in range(1,shape[2])
			if s[i,j] !== nothing
				print([i,j])

			end
		
		end
	end
end

𝒜 = [1, 2, 3, 4]
γ = 0.01
Q = Dict()
α = 0.01


𝒮 = initialize_game(3)




move(𝒮,𝒜[1])
# QLearning(𝒮, 𝒜, γ, Q, α)
