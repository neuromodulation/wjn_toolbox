function readkeys
% READKEYS reads all keyboard events since last call to READKEYS or CLEARKEYS
%
% Description:
%     Reads all keyboard events since last call to READKEYS or CLEARKEYS.  Key IDs are defined in the
%     structure returned by GETKEYMAP and the table shown below.
%         1 - A
%         2 - B
%         3 - C
%         4 - D
%         5 - E
%         6 - F
%         7 - G
%         8 - H
%         9 - I
%        10 - J
%        11 - K
%        12 - L
%        13 - M
%        14 - N
%        15 - O
%        16 - P
%        17 - Q
%        18 - R
%        19 - S
%        20 - T
%        21 - U
%        22 - V
%        23 - W
%        24 - X
%        25 - Y
%        26 - Z
%        27 - 0
%        28 - 1
%        29 - 2
%        30 - 3
%        31 - 4
%        32 - 5
%        33 - 6
%        34 - 7
%        35 - 8
%        36 - 9
%        37 - F1
%        38 - F2
%        39 - F3
%        40 - F4
%        41 - F5
%        42 - F6
%        43 - F7
%        44 - F8
%        45 - F9
%        46 - F10
%        47 - F11
%        48 - F12
%        49 - F13
%        50 - F14
%        51 - F15
%        52 - Escape
%        53 - Minus
%        54 - Equals
%        55 - BackSpace
%        56 - Tab
%        57 - LBracket
%        58 - RBracket
%        59 - Return
%        60 - LControl
%        61 - SemiColon
%        62 - Apostrophe
%        63 - Grave
%        64 - LShift
%        65 - BackSlash
%        66 - Comma
%        67 - Period
%        68 - Slash
%        69 - RShift
%        70 - LAlt
%        71 - Space
%        72 - CapsLock
%        73 - NumLock
%        74 - Scroll
%        75 - Pad0
%        76 - Pad1
%        77 - Pad2
%        78 - Pad3
%        79 - Pad4
%        80 - Pad5
%        81 - Pad6
%        82 - Pad7
%        83 - Pad8
%        84 - Pad9
%        85 - PadSubtrack
%        86 - PadAdd
%        87 - PadDivide
%        88 - PadMultiply
%        89 - PadPeriod
%        90 - PadEnter
%        91 - RControl
%        92 - RAlt
%        93 - Pause
%        94 - Home
%        95 - Up
%        96 - PageUp
%        97 - Left
%        98 - Right
%        99 - End
%       100 - Down
%       101 - PageDown
%       102 - Insert
%       103 - Delete
%
% Usage:
%     READKEYS
%
% Arguments:
%     NONE
%
% Examples:
%
% See also:
%
% Cogent 2000 function.

global cogent;

error( checkkeyboard );

if ~isfield(cogent.keyboard,'hDevice')
   message = 'START_COGENT must be called before calling READKEYS';
end

[ t, c, value ] = CogInput( 'GetEvents', cogent.keyboard.hDevice );

%cogent.keyboard.time  = floor( t/1000 ); % time now in seconds not us 4-4-2002 e.f.
cogent.keyboard.time = floor( t * 1000 );
cogent.keyboard.id    = c;
cogent.keyboard.value = value;
cogent.keyboard.number_of_responses = length( cogent.keyboard.time );
