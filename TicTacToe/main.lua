display.setStatusBar(display.HiddenStatusBar)

local centerX = display.contentWidth/2
local centerY = display.contentHeight/2
local pieceSize = 65
local currentTurn = 'X'
local theBoard = {}

local currentTurnMsg

local gameStatusMsg

local resetGameButton

local resetGameButtonText

local createPiece

--
--	createPiece() - Draws a single tic-tac-toe game piece
--
createPiece = function( x, y, size )
	--
	-- create a rectangle first
	--
	local piece = display.newRect( 0, 0, size, size )
	
	-- move the piece
	piece.x = x
	piece.y = y
	
	-- change the color of this 'piece' to be gray color with 2 - pixel light blue border
	piece:setFillColor( 117, 117, 117, 255 )
	piece:setStrokeColor( 0, 0, 142, 255)
	piece.strokeWidth = 2
	
	piece.label = display.newText( '', 0, 0, native.systemFont, 48 )
	piece.label.x = piece.x
	piece.label.y = piece.y
	
	--change the text color to 		
	--piece.label:setFillColor( 69, 0, 68, 255 )
	
	-- add a 'touch' listener to the grid piece
	piece:addEventListener( 'touch', onTouchPiece )
	
	return piece
	
end	

--
-- createBoard() draw tic-tac-toe game board
--
createBoard = function()
	
	--
	-- draw the board (3x3) g
	--
	
	local startX = centerX - pieceSize
	local startY = centerY - pieceSize
	theBoard = { {}, {}, {} }
	
	for row = 1, 3 do
		local y = startY + (row - 1) * pieceSize
		
		for col = 1, 3 do
			local x = startX + (col - 1) * pieceSize
			
			local piece = createPiece( x, y, pieceSize )
			
			theBoard[row][col] = piece
			 
		end
	end
	
	--
	-- 2. Add a current turn marker (text object).
	--
	currentTurnMsg = display.newText( "Current Turn: " .. currentTurn , 0, 0, native.systemFont, 24 )
	currentTurnMsg.x = centerX
	currentTurnMsg.y = centerY - 2 * pieceSize
	
	--
	-- 3. Add a winner indicator (text object).
	--
	gameStatusMsg = display.newText( "No winner yet..." , 0, 0, native.systemFont, 24 )
	gameStatusMsg.x = centerX
	gameStatusMsg.y = centerY + 2 * pieceSize -- Spaced two piece heights below center.
	
		--
	-- A. Create the rectangle base first.
	-- 
	resetGameButton = display.newRect( 0, 0, currentTurnMsg.width, currentTurnMsg.height) 

	-- Again, change reference point of rectangle, then position it.
	resetGameButton.x = centerX
	resetGameButton.y = centerY - 2 * pieceSize -- Spaced two piece heights above center.

	-- Use same color scheme as the board pieces
	resetGameButton:setFillColor( 32,32,32,255 )
	resetGameButton:setStrokeColor( 128,128,128,255 )
	resetGameButton.strokeWidth = 1

	-- Add a different listener unique to just this button (rectangle)
	resetGameButton:addEventListener( "touch", onTouchResetButton )

	-- Hide the button (rectangle) for now.
	resetGameButton.isVisible = false

	--
	-- B. Create the text label second.
	--
	-- Again, create the text object, then position it to get the results we want.
	resetGameButtonText =  display.newText( "Reset Game", 0, 0, native.systemFont, 24 )
	resetGameButtonText.x = centerX
	resetGameButtonText.y = centerY - 2 * pieceSize -- Spaced two piece heights above center.

	resetGameButtonText:setFillColor( 0.5,0.5,0.5,255 )

	-- Hide the label (text object)
	resetGameButtonText.isVisible = false	
	
end

--
-- =
-- Check For Winner() This function checks to see if either 'X' or '0' has won the game
--
checkForWinner = function( turn )

	local board = theBoard
	
	print( 'Check winner' )
	--check all rows 
	for i = 1, 3 do
		for j = 1, 3 do
			if ( board[i][j].label.text ~= turn ) then
				break
			elseif ( j == 3 ) then
				return true
			end
		end
	end
	
	--chek all colunms
	for i = 1, 3 do
		for j = 1, 3 do
			if ( board[j][i].label.text ~= turn ) then
				break
			elseif ( j == 3) then
				return true
			end	
		end
	end	
	
	--check all diagonals
	for i = 1, 3 do
		if ( board[i][i].label.text ~= turn ) then
			break	
		elseif ( i == 3 ) then
			return true
		end
	end
	
	for i = 1, 3 do
		if ( board[4-i][i].label.text  ~= turn ) then
		 	break
		elseif ( i == 3) then
			return true
		end
	end
	
	return false		

end

--
-- ========================
-- check board is full or not
--
isBoardFull = function ()
	
	local board = theBoard
	
	for i = 1, 3 do
		for j = 1, 3 do
			if ( board[i][j].label.text == '' ) then
				return false
			end
		end
	end
	
	return true
	
end


--
-- ========================LISTENER
--

onTouchPiece = function( event )
	
	local phase = event.phase
	local target = event.target
	
	if (phase == 'ended') then
		if (target.label.text == '') then
		
			target.label.text = currentTurn
			
			if ( checkForWinner( currentTurn ) ) then
			
				print('Winner is: ' .. currentTurn)
				gameStatusMsg.text = currentTurn .. " wins!"
				currentTurnMsg.isVisible = false
				gameIsRunning = false

				resetGameButton.isVisible = true
				resetGameButtonText.isVisible = true
				
			elseif ( isBoardFull() ) then
				
				print("No Winner!")
				gameStatusMsg.text = "Stalemate!"
				currentTurnMsg.isVisible = false
				gameIsRunning = false

				resetGameButton.isVisible = true
				resetGameButtonText.isVisible = true
				
			end
			
			if (currentTurn == 'X') then
				currentTurn = 'O'
				target.label:setFillColor( 69, 0, 68, 255 )
			else 
				currentTurn = 'X'
				target.label:setFillColor( 0, 173, 0, 255 )
			end	
			
			--currentTurnMsg.text = "Current Turn: " .. currentTurn
			
			
		end	
	end

end


-- ==
--    onTouchResetButton() - Touch handler function for the reset button.
-- ==
onTouchResetButton = function( event )
	local phase  = event.phase
	local target = event.target

	-- Reset the board markers and board data. i.e. Clear them.
	for row = 1, 3 do
		for col = 1, 3 do
			-- Clear the board text for this piece
			theBoard[row][col].label.text = ""
		end
	end

	-- Reset the current turn to "X"
	currentTurn = "X"

	-- Reset the messages to their initial values.
	currentTurnMsg.text = "Current Turn: " .. currentTurn
	currentTurnMsg.isVisible = true
	gameStatusMsg.text = "No winner yet..."

	-- Enable the game
	gameIsRunning = true

	-- Hide the reset button
	resetGameButton.isVisible = false
	resetGameButtonText.isVisible = false

	return true
end

-----------------------------------------------
-- execution
-----------------------------------------------
createBoard()