// -----------------------------------------------------------------------------
// Copyright 2011 Patrick Näf (herzbube@herzbube.ch)
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
#import "GtpCommand.h"
#import "GtpClient.h"
#import "../ApplicationDelegate.h"


// -----------------------------------------------------------------------------
/// @brief Class extension with private methods for GtpCommand.
// -----------------------------------------------------------------------------
@interface GtpCommand()
/// @name Initialization and deallocation
//@{
- (id) init;
- (void) dealloc;
//@}
/// @name Other methods
//@{
- (NSString*) description;
//@}
@end


@implementation GtpCommand

@synthesize command;

// -----------------------------------------------------------------------------
/// @brief Convenience constructor. Creates a GtpCommand instance that wraps
/// the command string @a command.
// -----------------------------------------------------------------------------
+ (GtpCommand*) command:(NSString*)command
{
  GtpCommand* cmd = [[GtpCommand alloc] init];
  if (cmd)
  {
    cmd.command = command;
    [cmd autorelease];
  }
  return cmd;
}

// -----------------------------------------------------------------------------
/// @brief Initializes a GtpCommand object.
///
/// @note This is the designated initializer of GtpCommand.
// -----------------------------------------------------------------------------
- (id) init
{
  // Call designated initializer of superclass (NSObject)
  self = [super init];
  if (! self)
    return nil;

  self.command = nil;

  return self;
}

// -----------------------------------------------------------------------------
/// @brief Deallocates memory allocated by this GtpCommand object.
// -----------------------------------------------------------------------------
- (void) dealloc
{
  self.command = nil;
  [super dealloc];
}

// -----------------------------------------------------------------------------
/// @brief Returns a description for this GtpCommand object.
///
/// This method is invoked when GtpCommand needs to be represented as a string,
/// i.e. by NSLog, or when the debugger command "po" is used on the object.
// -----------------------------------------------------------------------------
- (NSString*) description
{
  return [NSString stringWithFormat:@"GtpCommand(%p): %@", self, self.command];
}

// -----------------------------------------------------------------------------
/// @brief Submits this GtpCommand instance to the application's GtpClient.
///
/// This is a convenience method so that clients do not need to know GtpClient,
/// or how to obtain an instance of GtpClient.
// -----------------------------------------------------------------------------
- (void) submit
{
  NSLog(@"Submitting %@...", self);
  GtpClient* client = [ApplicationDelegate sharedDelegate].gtpClient;
  [client submit:self];
}

@end