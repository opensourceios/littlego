// -----------------------------------------------------------------------------
// Copyright 2013-2015 Patrick Näf (herzbube@herzbube.ch)
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


// -----------------------------------------------------------------------------
/// @brief The TwoFingerTapGestureController class is responsible for managing
/// the two-finger-tap gesture in #UIAreaPlay. Two-finger-tapping is used to
/// zoom out on the Go board.
///
/// Every two-finger-tap performs a 50% zoom-out. Repeated two-finger-taps zoom
/// out up to the minimum zoom scale. Once the minimum zoom scale has been
/// reached, additional two-finger-taps have no effect.
// -----------------------------------------------------------------------------
@interface TwoFingerTapGestureController : NSObject
{
}

@property(nonatomic, assign) UIScrollView* scrollView;

@end
