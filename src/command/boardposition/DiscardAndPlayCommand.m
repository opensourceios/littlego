// -----------------------------------------------------------------------------
// Copyright 2012-2013 Patrick Näf (herzbube@herzbube.ch)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// -----------------------------------------------------------------------------


// Project includes
#import "DiscardAndPlayCommand.h"
#import "../game/ContinueGameCommand.h"
#import "../move/ComputerPlayMoveCommand.h"
#import "../move/PlayMoveCommand.h"
#import "../../go/GoBoardPosition.h"
#import "../../go/GoGame.h"
#import "../../go/GoMoveModel.h"


// -----------------------------------------------------------------------------
/// @brief Enumerates different types of commands that DiscardAndPlayCommand
/// knows how to execute.
// -----------------------------------------------------------------------------
enum PlayCommandType
{
  PlayCommandTypePlayMove,
  PlayCommandTypePlayForMe,
  PlayCommandTypeContinue
};


// -----------------------------------------------------------------------------
/// @brief Class extension with private methods for DiscardAndPlayCommand.
// -----------------------------------------------------------------------------
@interface DiscardAndPlayCommand()
/// @name Initialization and deallocation
//@{
- (id) initWithCommandType:(enum PlayCommandType)aPlayCommandType;
- (void) dealloc;
//@}
/// @name Private helpers
//@{
- (bool) shouldDiscardMoves;
- (bool) discardMoves;
- (bool) playCommand;
//@}
/// @name Private properties
//@{
@property(nonatomic, assign) enum PlayCommandType playCommandType;
@property(nonatomic, assign) enum GoMoveType moveType;
@property(nonatomic, retain) GoPoint* point;
//@}
@end


@implementation DiscardAndPlayCommand

@synthesize playCommandType;
@synthesize moveType;
@synthesize point;


// -----------------------------------------------------------------------------
/// @brief Initializes a DiscardAndPlayCommand object that will make a play
/// move at @a point.
// -----------------------------------------------------------------------------
- (id) initWithPoint:(GoPoint*)aPoint
{
  assert(aPoint);
  if (! aPoint)
    return nil;
  self = [self initWithCommandType:PlayCommandTypePlayMove];
  self.moveType = GoMoveTypePlay;
  self.point = aPoint;
  return self;
}

// -----------------------------------------------------------------------------
/// @brief Initializes a DiscardAndPlayCommand object that will make a pass
/// move.
// -----------------------------------------------------------------------------
- (id) initPass
{
  self = [self initWithCommandType:PlayCommandTypePlayMove];
  self.moveType = GoMoveTypePass;
  return self;
}

// -----------------------------------------------------------------------------
/// @brief Initializes a DiscardAndPlayCommand object that will delegate the
/// move to the computer player.
// -----------------------------------------------------------------------------
- (id) initPlayForMe
{
  return [self initWithCommandType:PlayCommandTypePlayForMe];
}

// -----------------------------------------------------------------------------
/// @brief Initializes a DiscardAndPlayCommand object that will continue a
/// computer vs. computer game that is paused.
// -----------------------------------------------------------------------------
- (id) initContinue
{
  return [self initWithCommandType:PlayCommandTypeContinue];
}

// -----------------------------------------------------------------------------
/// @brief Initializes a DiscardAndPlayCommand object that will make a move
/// based on @a aPlayCommandType and the property values found when the command
/// is executed.
///
/// @note This is the designated initializer of DiscardAndPlayCommand.
// -----------------------------------------------------------------------------
- (id) initWithCommandType:(enum PlayCommandType)aPlayCommandType
{
  // Call designated initializer of superclass (CommandBase)
  self = [super init];
  if (! self)
    return nil;

  self.playCommandType = aPlayCommandType;
  self.moveType = -1;
  self.point = nil;

  return self;
}

// -----------------------------------------------------------------------------
/// @brief Deallocates memory allocated by this DiscardAndPlayCommand object.
// -----------------------------------------------------------------------------
- (void) dealloc
{
  self.point = nil;
  [super dealloc];
}

// -----------------------------------------------------------------------------
/// @brief Executes this command. See the class documentation for details.
// -----------------------------------------------------------------------------
- (bool) doIt
{
  bool shouldDiscardMoves = [self shouldDiscardMoves];
  if (shouldDiscardMoves)
  {
    bool success = [self discardMoves];
    if (! success)
      return false;
  }
  bool success = [self playCommand];
  return success;
}

// -----------------------------------------------------------------------------
/// @brief Private helper for doIt(). Returns true if moves need to be
/// discarded, false otherwise.
// -----------------------------------------------------------------------------
- (bool) shouldDiscardMoves
{
  GoGame* game = [GoGame sharedGame];
  GoBoardPosition* boardPosition = game.boardPosition;
  if (boardPosition.isLastPosition)
    return false;
  else
    return true;
}

// -----------------------------------------------------------------------------
/// @brief Private helper for doIt(). Returns true on success, false on failure.
// -----------------------------------------------------------------------------
- (bool) discardMoves
{
  GoGame* game = [GoGame sharedGame];
  enum GoGameState gameState = game.state;
  assert(GoGameStateGameHasEnded != gameState);
  if (GoGameStateGameHasEnded == gameState)
    return false;
  GoBoardPosition* boardPosition = game.boardPosition;
  int indexOfFirstMoveToDiscard = boardPosition.currentBoardPosition;
  GoMoveModel* moveModel = game.moveModel;
  [moveModel discardMovesFromIndex:indexOfFirstMoveToDiscard];
  return true;
}

// -----------------------------------------------------------------------------
/// @brief Private helper for doIt(). Returns true on success, false on failure.
// -----------------------------------------------------------------------------
- (bool) playCommand
{
  CommandBase* command = nil;
  switch (self.playCommandType)
  {
    case PlayCommandTypePlayMove:
    {
      switch (self.moveType)
      {
        case GoMoveTypePlay:
          command = [[PlayMoveCommand alloc] initWithPoint:self.point];
          break;
        case GoMoveTypePass:
          command = [[PlayMoveCommand alloc] initPass];
          break;
        default:
          break;
      }
      break;
    }
    case PlayCommandTypePlayForMe:
    {
      command = [[ComputerPlayMoveCommand alloc] init];
      break;
    }
    case PlayCommandTypeContinue:
    {
      command = [[ContinueGameCommand alloc] init];
      break;
    }
    default:
    {
      break;
    }
  }

  if (command)
  {
    [command submit];
    return true;
  }
  else
  {
    return false;
  }
}

@end
