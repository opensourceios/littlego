// -----------------------------------------------------------------------------
// Copyright 2011-2012 Patrick Näf (herzbube@herzbube.ch)
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
#import "../CommandBase.h"

// Forward declarations
@class GoGame;


// -----------------------------------------------------------------------------
/// @brief The RestoreGameCommand class is responsible for restoring a backed
/// up game during application startup.
///
/// If RestoreGameCommand finds a backup .sgf file in the application's library
/// folder, it assumes that the application crashed or was killed while
/// suspended. It starts a new game with the content of the backup .sgf file
/// and using the current user defaults for "new games". It also restores the
/// board position last viewed by the user within that game.
///
/// The net effect is that the application is restored as close as possible to
/// the state it had when it was last seen alive by the user.
///
/// If RestoreGameCommand finds no backup .sgf file, it simply starts a new
/// game.
///
/// @see BackupGameCommand.
// -----------------------------------------------------------------------------
@interface RestoreGameCommand : CommandBase
{
}

- (id) init;

@end
