// SPDX-License-Identifier: Grantware
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ImmutableInclusionVerifier} from "./ImmutableInclusionVerifier.sol";

/// @title RedistributionChef
/// @notice Join the redistribution!
/// X̴̢̡̫̣̝̖͉̩̹̝͕̪̝̣̥͖̠̣̦͙̬͔͕̤̩̱̗͉̱͍̏͊̎̊̽̋̈̔̽̐͜͠X̸̡̡̨͇̤͉̟̗̠̞̱̱͔̮̗̪̜͎̪̼͔̜̦͙̜̮̝͖̪͈̳̼͆̈́̓̊̄͂̈́̏͆̋̓̚͠ͅͅX̶̨̛̮̘̬̺̮̮͕͓̫͔̯̱͉̋͌͊̊̂͐͗͛̄̓͋͐̋̈́̓̋̚̕͘̕͝ͅX̴̡̩̪͕̬̯͇͇͉̪̖͇̭̖́͌̍̌̉̊͒̑̂̎̈̿̉̆́̕͜͠͠͝ͅX̸̢̢̭̦͈͔͕̤̬̺̲͈̝̤͉̹̦͉̞͑̈́̈́̌̂͆̋̂̃̅̚͝ͅͅX̷̛̛̬͍̓̉̎̒͊̓̆̎̆͝X̵̧̩̮̜͙͉̅̊́̇̃͜X̷̨̟̪̠̖̥̠͓̟̰̘̭̿͒ͅͅX̸̢̛̯̺͍̜̊̽̅̈́̽͆̀̉̏͊͑́̔͋͊̏͗͒̏̚͜͠͠X̸̧̧̧̦̖͕̯̺̱̬̳̦͔̣̙̝̦̞̣̠̠̰̭̖͖̤̓̈́̓̎̑̏̒͊̃̌̑͋͋́̌̉̇͘͠͝ͅͅX̶̧̧̧̛̤̱̤͔̱͎̖͎̣̬̤̫̣̦̳̜̫̲̭͔͐͋͑̿̈͆̎̈̾̐́̀̃̃̂̀͊̽̈̎̄̌̀̎͘̕̕̕̕͜͝͠͝ͅX̶͇̍̿̄̔͗͊̀̊͐̊̐̎̏͆́̎̒̂̅̚͘͘̚͝ͅX̵̢̧̨͖̺͎̗̜͓̤̠̿̎̃̓̓̄̏͂́̈́̾̚͜͝ͅX̴̧̨̡̨̩͍͖͇̣͕̤̖̫͈̻̭̖̘̜͇͕͍̬͈̀̋̽̑͂́̓͂̓̒͐̈́̅͂͛̃͆̾͊͐̉̓̔̊͘͠͝Ẋ̸̤̤̬̘̲̈͛̔̃͆̚͠ͅX̵̡̧̨̘̥̼̰͕̝̟̞̙͉̥̖̹̜̲̳̭͓̲̬̱̘̀̀̎̅̃̓̿̋̓́̈͊̊̈́͋͆̈́̉̔̃̋̓̍̀̓̿͂̽̀͋̚͜͜͠͝͠ͅẌ̴̡͖̹̞̰́̓͜X̷̛̛̛͔̭͍̯̻͚͋͑͛̄̆̊͛̍̔͊̊̈́͌̿̌̓͌̂̈́̚̚͝X̴̢̠̣̖͍̖̝̊͆̀̃̈́̀̀͌̇͗̑͊̑͜͝ͅͅX̵̢̬͖̫̺͈̥͈̫̻̹͈̭͚̗͇̎͌̉͐͂̀̓̔͑̐̂̑̾͂͂̆̿̈́̊̒̆̌̈́̋̅͌͝ͅX̴̨̡̛͔̰͎̗̗͚̱͈̝̣̬̘͖̞̜͍͆͂͐̃̆̆̅͒̄͂̂́̽̏̀͂̆͒͛͌́͛͌͗̈́̈̐͋̿͘̕͝X̴̡̭̠̜̠̜̗̥͕̺̹̹̗̮̳͊̅X̸̨̛̛̛̪̜͍̣̯͈̫̬̣̮͇͓̝̰̝̫͔̹͔̠͆̇̎̀̓͋̒͑͆̍͋̀́̀͐̕͘͘͠͠ͅX̶̢͖̜̭͕̳̥̩̺̤̖͙͕̻̲̮̖̤̞̭̩̦̑̈́̉͑́̄͗̓̌͆̀X̶̢̧̧̬̘̤̳͙̟̱̞̝͖̜̳̬͊̈̑̇̐̄̄̉͛̐͒̀̇̅̽̌̏̎̏̀̈͝ͅẌ̵̳̦̄̏̍̏̆̉̋̏͑̊̑̾͗̽͘͝͠ͅX̸̢̢̰̣̻̦͔̮̘͔̰̺̦͆̈́͊̃̓͐̿̿́̈́̋́́̀͑͘̕͝͝ͅX̵̡̤͍̘͕͈̲͉͔͔̺͕̖͉̫͆̔̏̽̐͌͊̂̎̾͊͐͆́̓̉͂͊͛̃̏̎́̀̀́͘͜X̴̛̲͇͎͚̻̣̱̭͓̪̊͆̇̍̇̈́̍͐͋̌̌͗͂̏̐͗͌͂͐̍̅͌̈́̐̓̉̆͌̾͒͜͝X̶̬̘͚̾͑̈́́́͊̔͐̚X̶̨̻̙̳͉͍̼̣̭̯̦̽̈́͊̾̓̓͒͊̈́͐̐́͋̎͑̈́̋̾̈́̇̈͛̕̕̚͝͠͠͝͝X̵̡̢̢̰̝͎̞̦͇̤̹͉̩̗̺̬̮̤̽͐̑̔͐̊̿̅̈̂͆̅͘ͅͅX̷̦̰̃̒̎̈͒͌̇̈́͐̊̉̅̃̊͂̅̑̄̈͛̏̇̅̌̕͝͝ͅẊ̴̡̢̨̛̯̳̘̲͚̻͔̫̘̳͕͓̙͙͎̻͓͂̏̏̍͗͆̓̀̔̈́̐̒̊̔̍̉́̏̃͆̏͘̚͘͝͝X̶̢̛̛̞͍̻̠̝̟̫͉̬̟̱̺̩̉̈́͛͗̏͂͋̍̿̀̅͆̄̎̆͊͊̂͑͊́͛̃̔̓͋́͘̚͝͠X̴͇̝͍͐͊̎X̶̧̧̢̣̗̪̺̱͈̼͎̻͓͓͕͔͔̺̞̻̠͓̬̮̺̠̳̂̓͌̏͗͜͜͝͠X̸̛͚̩͙͚̹̮̮̹̻̰̟͍̼͚́̐͛̀̂̍̅͑͒̎̔͑̂̃͋͒̋̏́̏͐̄̚͘̕͠X̴̱̯̠͎̋͊X̸̨̧̧̨͈̱͎̤̠͎̹̰̰̥̝̟͎͕͎͙̏̊̂̋̽̂̓͋͗̄̓͘͘͜X̷̨̢̨̡̰̯͓̥̩̰͓̪̟̱̦̝͈͍͇̟̤̣̬͖̠͈̹̠̻͎͎̼͂͛́͒̒͌̌̈́̒̿̅͋̿͐͠ͅͅX̶̨̲̝͇͍̘͈͓̟͎̖̱̲̖̳̝̮͔̹͖̾̍͋͒̈́͌͜ͅX̸̢̧̡̼̖̳̬̱̘̱͕̩͙̦͓̰͎̲̗̤͚͉̭͓̮̤͋̂͒X̸̨̦̝̯̟̰͕̭̩̟̠̬̫̬̽̀͊̓̋̔̂͌̋X̷̡̟̠̻̳̘͈̯̲͇̜̻̯̘̲̞̻̤͎̦̖͈͎̺̞͋̀̔̎̀͊́͆̔́͊̒̈́͘̕X̷̨̢̢̹̥̪̱̜͔̝̲͇̑̏̽̿͗̂̑̕̚ͅX̶͉͛̆͒̆̿̓̇͒̇̃̍̑̅͆̇̑̃͆X̵̢̛͔̤͔͎̞͕͕̥̫̅̊͒̌̄͗̄̈́̔̉͊̌̐̑͑̌̆̽̐̾͒̆͛́̿̀̊͌̓̆͝ͅX̷̡̧̤̗̠̜͇̘̝̪̺̖̻̟͙̘̯͕̙̰̗̗̝̥̓̅̌̃̐̎͝͠͝ͅX̸̡̧̧̜̫͈̮̗͈̬͖͓͉̘͓͇̝̹̆͌̿͌͐̀̏̚͜͝X̵͓̤̠̼̫̬̭̰͖̺͍̹̜̤̳̼̩͍̫͔̑̈̈́͝ͅͅX̶̢̖̜̫̯̗̞͕͖̹͍̰̯͕̲̺͖̌́͛̒͠͠Ẍ̸̡̛̣̮̟̮̰̮͋͛͑̾́̾̿͊͒̋̊̏̍̋͗̀̓͒̓̈́̎̂̿̅̑̃͒́̈́̚ͅX̸̛̘̖̖̹̦̲̫̺̭̜̌͒͆̊́͑̇͊̈́̾̐̉̓̓̇̆̐̿̄́͛̄̔̊͑̔͘͘͝X̶̡̨̱̲̪̙̑͂͂X̶̼̟̄̂́̏̃̆̓̌̓̄̔̈̌͋̉̀͜͝X̴̼̗̱̤͖͈̰̰̫̞͎̪͕̺̘͎̭̪̹̙̖͊́̈́̀̄̆͂͌̓́̈́̎̽̃͋̌͂́̋͑̽̀͒̕͜͜͜͠͝͠͝͝͝͠X̸̡̨̨͔͍̩̲̺͓͙̯̲̬͍̹̰̤͙̠̣̥͔̣̦̣̜̩̭͓̠̿̑̅͆̉̒̃͗̋̿̋͗̈́̚̕ͅͅX̵̨̛͓̝̗̜̗̘͙̌͆͗̌͒̈́̋̈́̿̉̓̍͒͂́͆̈́͗́̿̔̚͘͠͠͠͝͠X̸̢̢͈͔̟̌̒̐̇̀͋̾͗͊́̈́͗̉̋̋̽̔͆͊̿̔͝͝X̴̨̡͍̘̰̺͎̝̭̥̾̓͗͝ͅX̷̢̛͍̼̖̫̙̜̗̦̬́́̓̈́͗̃̏̑̑̇̋͗̆̽̉̔́̆̆͊̐̌͑̃͐͐͒͘͝͝X̶̨͔̦̻̘͕͖͈͈̭̻͍͚̫̃̂̿̈́̓̀͂͜Ẍ̸̨̛̺̲̩̝̺͔͉̪̪͈̗͍̦̠̖́̃͐͒̐̊͛̐̅̿̓̅̅̂͑̏́̈͘̕̚̚͘͘̚̚̕͘͜͜͝X̸̛̘̯͕͕͌̆̾̉̎͒͐̂͒̈́̑̑̅̂̓͋͐̐̆̐̈̓̍͘̕͝ͅX̶̢̧̛̛͕̗̠͕̥̮͍́̿́̈́͋͒̓̔̾̃̃̂̒͗̆͘̕̕͠͝͠͝X̸̨̡̨̗͇̰͉̩̙̹̎̏̀̽̀͗͐̍͗̍̊Ẍ̵̢̡̼͖̯̰͉̻̦̖̗̺̫̣̫̳̹̗̖̯̪͖̭̳͌̆̀̀̓̍͑͗̈́͛̑̊̊͊̕͘ͅX̴̛̫̺̪͖͉̟͈͇́̾̐̀̏̈́́Ẍ̴̡̙͈͉͎̗́̉̀̑̊͐̄͛̑̊X̷͍͙̐̓̃̏̂̂̋̎͑̑́͑͆͐̅̄̎̾̊͊͊͆̐͒͌͘͘͝X̸̜̰̘̙̃̓͋̕X̸̨̡̢̗̖̲̬͓̺̪̐̄̀̏̂̒͛̅͂͋̓̚̚Ẍ̸̧̨̘͔̼̼͙͙͈̹̦͕͎̖̖̠̦̼́̉͋̈́̎̒̈́̂̏̂̔̎̈́͋͋̒́̾͐̚͝͝Ẍ̵̨̡̼̳͖̳̝́̎͘ͅX̷̡̧̛̛͎̩̩͕̝͕̬̳͈̺͖̱̘̣̗͔̔́́͑̑̌̑́̑̃̾̈̑̀̍̀̀̀̊̈́̽̕Ẋ̵̧̟͚͇̤͚̬̮̫̣̜̻͇̠̠͉̣͍̺̂̀̆̂̊̌͘͘͜X̴̧̛͓̹͇̱̠̟̭͓̞̥̹̠̻̳͈̦̿̎̌̈́̈͂͆̊̇̐̎͘̕͜͠
/// XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
/// XX                                                                          XX
/// XX   MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM   XX
/// XX   MMMMMMMMMMMMMMMMMMMMMssssssssssssssssssssssssssMMMMMMMMMMMMMMMMMMMMM   XX
/// XX   MMMMMMMMMMMMMMMMss'''                          '''ssMMMMMMMMMMMMMMMM   XX
/// XX   MMMMMMMMMMMMyy''                                    ''yyMMMMMMMMMMMM   XX
/// XX   MMMMMMMMyy''                                            ''yyMMMMMMMM   XX
/// XX   MMMMMy''                                                    ''yMMMMM   XX
/// XX   MMMy'                                                          'yMMM   XX
/// XX   Mh'                                                              'hM   XX
/// XX   -                                                                  -   XX
/// XX                                                                          XX
/// XX   ::                                                                ::   XX
/// XX   MMhh.        ..hhhhhh..                      ..hhhhhh..        .hhMM   XX
/// XX   MMMMMh   ..hhMMMMMMMMMMhh.                .hhMMMMMMMMMMhh..   hMMMMM   XX
/// XX   ---MMM .hMMMMdd:::dMMMMMMMhh..        ..hhMMMMMMMd:::ddMMMMh. MMM---   XX
/// XX   MMMMMM MMmm''      'mmMMMMMMMMyy.  .yyMMMMMMMMmm'      ''mmMM MMMMMM   XX
/// XX   ---mMM ''             'mmMMMMMMMM  MMMMMMMMmm'             '' MMm---   XX
/// XX   yyyym'    .              'mMMMMm'  'mMMMMm'              .    'myyyy   XX
/// XX   mm''    .y'     ..yyyyy..  ''''      ''''  ..yyyyy..     'y.    ''mm   XX
/// XX           MN    .sMMMMMMMMMss.   .    .   .ssMMMMMMMMMs.    NM           XX
/// XX           N`    MMMMMMMMMMMMMN   M    M   NMMMMMMMMMMMMM    `N           XX
/// XX            +  .sMNNNNNMMMMMN+   `N    N`   +NMMMMMNNNNNMs.  +            XX
/// XX              o+++     ++++Mo    M      M    oM++++     +++o              XX
/// XX                                oo      oo                                XX
/// XX           oM                 oo          oo                 Mo           XX
/// XX         oMMo                M              M                oMMo         XX
/// XX       +MMMM                 s              s                 MMMM+       XX
/// XX      +MMMMM+            +++NNNN+        +NNNN+++            +MMMMM+      XX
/// XX     +MMMMMMM+       ++NNMMMMMMMMN+    +NMMMMMMMMNN++       +MMMMMMM+     XX
/// XX     MMMMMMMMMNN+++NNMMMMMMMMMMMMMMNNNNMMMMMMMMMMMMMMNN+++NNMMMMMMMMM     XX
/// XX     yMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMy     XX
/// XX   m  yMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMy  m   XX
/// XX   MMm yMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMy mMM   XX
/// XX   MMMm .yyMMMMMMMMMMMMMMMM     MMMMMMMMMM     MMMMMMMMMMMMMMMMyy. mMMM   XX
/// XX   MMMMd   ''''hhhhh       odddo          obbbo        hhhh''''   dMMMM   XX
/// XX   MMMMMd             'hMMMMMMMMMMddddddMMMMMMMMMMh'             dMMMMM   XX
/// XX   MMMMMMd              'hMMMMMMMMMMMMMMMMMMMMMMh'              dMMMMMM   XX
/// XX   MMMMMMM-               ''ddMMMMMMMMMMMMMMdd''               -MMMMMMM   XX
/// XX   MMMMMMMM                   '::dddddddd::'                   MMMMMMMM   XX
/// XX   MMMMMMMM-                                                  -MMMMMMMM   XX
/// XX   MMMMMMMMM                                                  MMMMMMMMM   XX
/// XX   MMMMMMMMMy                                                yMMMMMMMMM   XX
/// XX   MMMMMMMMMMy.                                            .yMMMMMMMMMM   XX
/// XX   MMMMMMMMMMMMy.                                        .yMMMMMMMMMMMM   XX
/// XX   MMMMMMMMMMMMMMy.                                    .yMMMMMMMMMMMMMM   XX
/// XX   MMMMMMMMMMMMMMMMs.                                .sMMMMMMMMMMMMMMMM   XX
/// XX   MMMMMMMMMMMMMMMMMMss.           ....           .ssMMMMMMMMMMMMMMMMMM   XX
/// XX   MMMMMMMMMMMMMMMMMMMMNo         o0509o         oNMMMMMMMMMMMMMMMMMMMM   XX
/// XX                                                                          XX
/// XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
/// X̸̧̧̜̩̭͔̻̖͇̤̱̦̺̤̭̘̜̉̇̇͛̾͝X̷͉̥̬͔͍̦̘̔̀̀͌͘̕͠X̸̢̤͉͎̲̬̝͉̼͙̭̠̽͋̌̌̏̃̿̊̀̍͆X̵̨̛͉̺̬̥͉̻͔̰̖͇̥̪̺̞́͒̉̑̋̂͒̅̿̀̈́̃͒̾̾̈́̄̉̎͗̑͝X̶͈̝̽͝X̵̨̡̱̣̣̼̭̼̤̓̇̚X̸̨͙̤̫̻͓̠̺̬̤̺́̉̒̂͒X̵͇̥͔͙͎̪̫̜̻̼̤͈̤̬̤̥͓̂̎̔̀̀̌͂̀̈́͌̀̀̅̆̆̀̈́͛͌̔͝ͅX̵̨̛̯̼̠̊̈́̄̌͗͊̍̈́͗̇͑̅̚͠͝͝Ẍ̷̢̨̡̪͚̻̰̩̩͈̯͍̭͖̦̝͍͙̤̬̟̻̳́̀̏̕͘̚ͅX̵̛̲͓̍͌̋͊́̆͊̌̈̇͒̂̈́͝X̵̧̨̢͓͕̮̞͇̲͇͕̼̠̻̜̤̼̝̣̻̟͉̰̰̊͋̐͗̑́̊̓̏́̒̃͠X̷̧̡̧̧̨̛̺̱͍̠͉̟̘̭̥̭͔̯̱̯̜̲̫̠͖͊̔͑̓̍̋̃́̄̍̆̈́͛͐̂͜͠X̵̧̥̝̼͙̮̀̑̾͗̐͗̋̈́̅̽͋͌̑͜X̸̢̝̙̳̱̤͎̜̝̫̞͍̰̟̦̦̹̆̅̏̆͛̂̋̍͗͊̈̈́͝ͅX̶̛͈͉͎͚̦̊͆̆͗̎͐͐̑̋̆̌̔̽̚̕͝͠X̴̤̼̳͓̟̯̹͎̣͂̑̓̃̔X̶͍̥̝̬̼̉̆̊̆̀͒̇̓̔̃̈́̔̕͠͝ͅX̶̛̮͎̹̱̳̜̪̥̥͚͖͓̱̰̻͉̰͎͗͆̒̓̈́̿͆ͅX̸̲̺͇̱̭̲̖̤̗͕̯͎͔̗̲̭̦͚̻̖͖̬̪͊̓̍͑̾̎́̃̐̐͗̀̕͠X̸̛̘͈͉̹̹́͌̅̍̈͐̄͌̌̂́̒̓̊̏͂̌̏̅͊̚͜͝ͅX̵̰͙̰͈͍̗̓̌̈̓̈́̐̑̐̓̍̐̽̇͒̒͒͛͝͝X̵̢̙̘̬̾̋͒̈́̓̂̀͠X̸̨̧̧̟̘̰͔̰̭̰̱̳͔̳̬̞͙͑̿̆̏̀̆̈́̃̓͒̈́̄̾̿̿̍̑̋͛́́̈́͜ͅX̸̮̬͉̻̹͉͚̦͓̞͕͓̠͙͔̜̖̘̮̬̋̾̔̅̀̈́̍̇̈͂́̃͐̒̌̆͘͜͝X̷̱̓̿̈́͗̈́̏͑̈́́̅̆̊̎͒͘ͅX̸͖̱̟̦̙͚̝͎͋͌̊̿̊͊̑͑͗̿̚X̴̧̡̡̢̛̯̗̘͎̫̱̹̞̙̬̣͔̱̞̻̺͕̖̟̊̓̇̏̉͘͘̚͝ͅX̷̡͕̯̳͔̻̳͎̜̗̘̗̮̹͚͎̥̒͋ͅͅX̸̛̼͍̠̘͈̖͚̻͔̖̫̟̜̟̝̍̍͂̋͗̀̓̔̍̇͐͊̀̚͜͠͝͠X̶̛̝̪͚̭̗̹̱̳̻͓̠̫̮̮̓͆͌͗̒͛͋̀̓͑̈̉̐͆͛́̑̚͠͠͠X̸̡̛̮̿̀̋̃͑͋͗͑͊̇̊͌̄̋Ẍ̵̗͓͓͙̬̯͍͉͓́̾X̸̡̧̯̤͔̘̜̺͑̏̂͋͂ͅX̵̛̛̗͚̪͈̪̀̾̀́̓̒X̴̩̮̙̄X̵̡̧̧̡̤͔͇̗͉̜̳͈̲͔͍͈̤̭̒́̈́̾̉́̎̎͂̇̋͋̈́́̇͘͝͠X̷̨̛̮̯̭͕̤͉͗͒̌̆͛̽̎̑̏̔͗̐̅́͂̊̃̀̈̈́̈ͅX̵̛̱͈̺̱̹̿͌͐̉̿͘̕͘ͅX̷̗͊̈́̒̐̈́̌̓̀͝X̸̙͔̝̰̹̘͉̟̦͓̗͈̉͋̎̃̌͗̄̇̎̓̅́̒̐̾̎͆̿͋͒̕ͅͅX̸̡̢̢̖͙͚̻͚̦͈͓͖͂X̴̢͇͔̟̲̺̋Ẍ̵̨̨̡͕̺̲͚̭̭̖̻̩̟̳̘̲͕̻́̈́̓̈́̅̀̍͌X̷̛̛̣̬̜̙̖̤͔̼̹̩̦̭̪̠͈̙̺̳̝͎̀̿̂̌̒͂̑̈̈́̒̌͋̋͋͌̈̋͋͛͘̚͝͠X̵̢̻̗͉̖̿̂̈́̉̓͂̈̏͆̔́̈̓̌͗́̚͠ͅX̵̧̡̢̤̱̖̘̞̰͓̻͉̫̦͍̼̹̦̙͓̌̌̋̎̂͋̽̏̾͜X̶̨̦̆̓̅̍̏̌͊̈̐̉̂̀̍̉̌̍X̴̡͇͔̟̗̮̤͍̦̞̳̐͋̌̒̀̔̎̐́͂͊̚̕͠͠ͅͅX̶̨̧̛̟̳͓̝̜̼̤̬̜͕̞̱̻̯̫̹̟̄̍̿͋̚͜͠͝X̸̨͎̺̪͚̦͉̹̻̳̬͓̥͉̬͋̽̉͗ͅX̸̬̬̥̫̍͒̾̀͒͊̏̀̔̑́̈́͑̔̇̉͐́͝X̵͚̘̘̞̫̬̝̗̦͓̪́̒̔Ẍ̷̛͚̲͖̣͙̗͉͉̦͕͉͇̩̮̘̥̹̤̤̗̱̮̬͔́̆̎̑̾̇͊̅̏̓̔̑̽̓̽͒͝͠͝X̸̡̧̡̧̛̛͇͔̬̘̗̱̳̫̗̪̪̼̽́͐̂̎̍̆͊̅̀̍͘̕ͅX̶̢̢̨̢̳̠͕͔̮̟̜͎̼̘͉͇̞͒̆̓̿͗͆͘͠͝ͅX̷̛̜̦̦͙̹͇͕̰͇̱̰̬̭͚̤̮̣̞̀̊̋̐̇́͋̍͋͐̾̑͋̀̊͠͠͝X̶͖̖̭͙̩̯̤̥̄̀͒̑͆̊́́̅̈͑͗̍͋̐̇͗͋͑̚̕͜X̶̧̧̛̛̣̼͈̩̹̹͙̣̙͎̮̒̑̿͋̓̌̒̐̃̓̑͑̓̈́̈́͂̚͜X̶̢̱͙̼̯̼͇̳͈͎̮̤̪̅́́̇̈́̍̃̍̽̃͌͛͑̀̐̏̑͘͘͘͠ͅX̵̡̧̯̞͎͎̝̱͇͔̰͕̻̺͔͈̯̅͒́̈́̒͂̅͜͝X̸̡̨̛͙̫̞͖͚͎͖͆̆̓̊̓̓͌X̴̨̣̟̼͈͉͈̤̃́̆̐̓̌͒̋͐͒́̂͌̍̌͘͝͝͝͠͝͝X̶̨̛̛̳̒̃̽̆̇͐̿̏̿̌͑̓̏̇X̵̼̬̭̟͓̣̹͚̫͚͓̠̣̠͈͙͍̺͚̬̤͉̳̅̊̔̔̍̓̅͊̏̆̕̕͜X̵̛̯͖̥̪̖̣̹̼͆̑̇̐́͂̔̓̈̑̓̒̀̊͐̾̎̕͠X̶̢̖̠̣̦̳̳̩͖͈̲͔̗̬̦͖͒̂͐̔͑̽̑̅͌̉̈̂̔̀͑͑́̌̓͌͊͠͠͠ͅͅX̵̢̛͍͇̝̰̱̪̲̞̦̗̋͒̅̓̂̄͑̎͐͐̇̃͂̓̆̈̚͘͝X̴̟̤̫̹͎̟͚̲̯̜̮͖̫̱͔̤͔̗͍̟̂͊̎̃͆̑̈̅͊̅̈́̎̑͗͒̂̋͘̚͜X̸̢̩̫͍̱̦̳͋͂̀̀̇̅̊X̷̡̢̥̱͔͇̙͙̠̭̯̯͕̰̄̀̆̔̃̕̕͜͜ͅX̴̨̳̘͕̃̌̾̉͂̾̇̍̒̈́͆̉͗̓̑̿̈͘͝X̴̡̟͓̙̝͙̥̝̺̬̰͙̹̫̯̳̟̭̠͚̪͋͊̾̑͂̈́͂͂̍̽̉̀̎̈͛̀͑̄͝͠ͅX̶̛͙̯͉͖̙̻̙͆̑́̾̓̊̊̎͌͐͆̽͊͐̐̿͐͝͝Ẍ̸̨̢̧̙̫̳̳̮̞͇̺́͒̈̀̐̇̊̒̓̆̆̀́͐͋̀͘͝X̷͉̳͉̜̭̝̱̟͙̺̟̱͉̣̙̂̽͂͋̓̕͜͠X̷̢̨̢̢̢͓̬̬̹̭͉̥͕̼̮̩͙͉̜̖͎̫̭̀́̌͑̓̄̈́̌̍̑͌̈́̀̈́̍̾̌̅͜͝X̸̡̛̰̦̯̺̳̻͈̼̏͂͐̿͌̄̍͂̋͒̀̓̆̈́̓̇̕͘͝͠
///                                          o8o                .
///                                          `"'              .o8
///    o ooooo  .oooo.o  .ooooo.   .ooooo.  oooo   .ooooo.  .o888oo oooo    ooo
///     888  ' d88(  "8 d88' `88b d88' `"Y8 `888  d88' `88b   888    `88.  .8'
///     888    `"Y88b.  888   888 888        888  888ooo888   888     `88..8'
///     888    o.  )88b 888   888 888   .o8  888  888    .o   888 .    `888'
///    o888o   8""888P' `Y8bod8P' `Y8bod8P' o888o `Y8bod8P'   "888"      E8'
///                                                                 .R...R'
///                                                                 `8888'
contract RedistributionChef is ImmutableInclusionVerifier, Ownable {
    using SafeERC20 for ERC20;

    /// @notice Total number of participants
    uint256 public immutable totalParticipants;
    /// @notice Expected DAI winnings; claims are disabled if contract does not have at least
    ///     this amount of DAI balance
    uint256 public immutable expectedDaiWinnings;
    /// @notice DAI contract
    ERC20 public immutable dai;
    /// @notice Mapping of whether an address has claimed their redistribution share or not
    mapping(address => bool) public hasClaimed;
    /// @notice List of addresses that have claimed
    address[] public claimooors;
    /// @notice The timestamp after which it will be possible for claimoooooors to claim
    ///     the remaining unclaimed Dai in the contract
    uint256 public claimExpiryTimestamp;

    constructor(
        address daiAddress,
        uint256 totalParticipants_,
        uint256 expectedDaiWinnings_,
        bytes32 merkleRoot
    ) Ownable() ImmutableInclusionVerifier(merkleRoot) {
        dai = ERC20(daiAddress);
        totalParticipants = totalParticipants_;
        expectedDaiWinnings = expectedDaiWinnings_;
    }

    /// @notice Start timer for claims expiry
    function startClaimTimer() external {
        require(claimExpiryTimestamp == 0, "Expiry already set");
        claimExpiryTimestamp = block.timestamp + 7 days;
    }

    /// @notice Claim your redistribution share. Only call this function after the DAI winnings
    ///     have been deposited to this contract. You can only call this function once per address.
    /// @param proof Proof of inclusion of caller in the merkle tree
    function claim(bytes32[] calldata proof) external {
        require(
            claimExpiryTimestamp != 0,
            "Expiry not set, claims not started"
        );
        require(
            !hasClaimed[msg.sender],
            "There is no greater guilt than discontentment"
        );
        require(
            verifyMerkleProof(keccak256(abi.encodePacked(msg.sender)), proof),
            "Not part of the redistribution"
        );

        // Calculate claim amount first, before updating internal accounting
        uint256 claimAmount = calculatePerAddressClaimAmount();
        require(
            claimAmount * totalParticipants >= expectedDaiWinnings,
            "Winnings are not yet loaded"
        );

        // Internal effects
        hasClaimed[msg.sender] = true;
        claimooors.push(msg.sender);

        // External interaction: transfer calculated Dai claim to caller
        dai.safeTransfer(msg.sender, claimAmount);
    }

    /// @notice Calculate the amount of Dai each participant can claim
    function calculatePerAddressClaimAmount() private view returns (uint256) {
        uint256 participantsLeft = totalParticipants - claimooors.length;
        require(participantsLeft > 0);
        uint256 claimAmount = dai.balanceOf(address(this)) / participantsLeft;
        return claimAmount;
    }

    /// @notice Redistribute remaining Dai in the contract, available after some
    ///     specified block timestamp `claimExpiryTimestamp`.
    function redistributeRemainder() external {
        require(
            block.timestamp > claimExpiryTimestamp,
            "Claims have not expired"
        );
        uint256 nClaimooors = claimooors.length;
        require(nClaimooors > 0, "No claims have been made");
        uint256 perAccountClaimAmount = dai.balanceOf(address(this)) /
            nClaimooors;
        for (uint256 i = 0; i < nClaimooors; ++i) {
            dai.safeTransfer(claimooors[i], perAccountClaimAmount);
        }
    }

    /// @notice Get number of claimoooors
    function getNumClaimooors() external view returns (uint256) {
        return claimooors.length;
    }

    /// @notice Returns true if participants can start claiming
    function isClaimable() external view returns (bool) {
        return
            claimExpiryTimestamp != 0 &&
            calculatePerAddressClaimAmount() * totalParticipants >=
            expectedDaiWinnings;
    }

    /// @notice Withdraw balance of token from contract
    /// @param tokenAddress Address of ERC-20 to rescue
    function rescueTokens(address tokenAddress) external onlyOwner {
        bool claimExpiredAndNobodyClaimedWinnings = tokenAddress ==
            address(dai) &&
            block.timestamp > claimExpiryTimestamp &&
            claimooors.length == 0;
        bool isUninitialised = tokenAddress == address(dai) &&
            claimExpiryTimestamp == 0 &&
            dai.balanceOf(address(this)) < expectedDaiWinnings;
        require(
            tokenAddress != address(dai) ||
                claimExpiredAndNobodyClaimedWinnings ||
                isUninitialised
        );
        ERC20 token = ERC20(tokenAddress);
        token.safeTransfer(msg.sender, token.balanceOf(address(this)));
    }

    /// @notice Rescue ETH force-sent to contract
    function rescueETH() external onlyOwner {
        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent);
    }
}
