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




board = initialize_game(3)

display(board)
print("flip")
board = copy(reverse(board',dims=2))
display(board)

print("restore flip")
board =  copy(reverse(board,dims=2)')
# print("re-flip")

display(board)
# board =  transpose(slided_board)
# display(board)

