{***************************************************}
{                                                   }
{   Tic-Tac-Toe Version 1.1                         }
{   w/ two-player and play-against-computer modes   }
{                                                   }
{   02/2000, Travis Carden                          }
{   travis@traviscarden.com                         }
{                                                   }
{***************************************************}

program tic;

uses crt,graph,menu,stu;

const DelayValue=2500;

var x,y:integer;
    WinsOfX,WinsOfO,GamesOfCat:longint;
    OptionOf,PlayOf,TurnOf,LastGameOf:shortint;
    Square:array[1..9]of char;
    winner,cat,TurnOfX,FirstPlay,scenario,EscapeOut,returning,
     FirstGame:Boolean;
    PlayAgain,player:char;

procedure DrawBorder;
  begin
    SetFillStyle(1,0);
    if not returning then Bar(10,GetMaxY-35,GetMaxX-10,GetMaxY-25);
    SetColor(15);
    SetLineStyle(0,0,1);
    rectangle(10,30,GetMaxX-10,GetMaxY-30);
    SetTextStyle(0,0,2);
    SetColor(0);
    line(GetCenterX-TextWidth('Tic-Tac-Toe ')div 2,30,GetCenterX+
     TextWidth('Tic-Tac-Toe ')div 2,30);
    SetColor(4);
    CenterText(-2,20,'Tic-Tac-Toe');
    SetColor(2);
    CenterText(0,22,'Tic-Tac-Toe');
    SetColor(15);
    CenterText(2,24,'Tic-Tac-Toe');
  end;

procedure WriteCounters;
var XTally,OTally,CatTally:string;
  begin
    str(WinsOfX,XTally);
    str(WinsOfO,OTally);
    str(GamesOfCat,CatTally);
    SetTextStyle(0,0,1);
    SetColor(0);
    OutTextXY(65-TextWidth('ллллллл')div 2,110,'ллллллл');
    OutTextXY(65-TextWidth('ллллллл')div 2,190,'ллллллл');
    OutTextXY(65-TextWidth('ллллллл')div 2,275,'ллллллл');
    SetColor(15);
    OutTextXY(65-TextWidth(XTally)div 2,110,XTally);
    OutTextXY(65-TextWidth(OTally)div 2,190,OTally);
    OutTextXY(65-TextWidth(CatTally)div 2,275,CatTally);
  end;

procedure DrawScreen;
var l:shortint;
  procedure DrawNumbers;
    begin
      case l of
        1:OutTextXY(200,360,'1');
        2:OutTextXY(360,360,'2');
        3:OutTextXY(520,360,'3');
        4:OutTextXY(200,240,'4');
        5:OutTextXY(360,240,'5');
        6:OutTextXY(520,240,'6');
        7:OutTextXY(200,120,'7');
        8:OutTextXY(360,120,'8');
        9:OutTextXY(520,120,'9');
      end;
    end;
  begin
    if not returning then ClearDevice
    else
      begin
        SetColor(0);
        SetFillStyle(1,0);
        Bar3D(120,60,600,420,0,TopOff);
      end;
    DrawBorder;
    WriteCounters;
    SetLineStyle(0,0,3);
    SetTextStyle(0,0,1);
    SetColor(15);
    line(120,180,600,180);
    line(120,300,600,300);
    line(280,60,280,420);
    line(440,60,440,420);
    for l:=1 to 9 do
      begin
        if not returning then DrawNumbers
        else if square[l]='n' then DrawNumbers;
      end;
    SetLineStyle(0,0,1);
    SetColor(4);
    OutTextXY(65-TextWidth('X Wins')div 2,90,'X');
    SetColor(15);
    OutTextXY(65-TextWidth('X Wins')div 2+TextWidth('X '),90,'Wins');
    line(40,100,90,100);
    SetColor(2);
    OutTextXY(65-TextWidth('O Wins')div 2,170,'O');
    SetColor(15);
    OutTextXY(65-TextWidth('O Wins')div 2+TextWidth('O '),170,'Wins');
    line(40,180,90,180);
    SetColor(9);
    OutTextXY(65-TextWidth('Cat')div 2,245,'Cat');
    SetColor(15);
    OutTextXY(65-TextWidth('Games')div 2,255,'Games');
    line(40,265,90,265);
  end;

procedure EmptySquares;
var c:shortint;
  begin
    for c:=1 to 9 do square[c]:='n';
  end;

procedure PutPreviewOf(b:char);
  procedure PutPreviewOfX;
    begin
      MoveTo(40,330);
      LineTo(45,325);
      LineTo(65,345);
      LineTo(85,325);
      LineTo(90,330);
      LineTo(70,350);
      LineTo(90,370);
      LineTo(85,375);
      LineTo(65,355);
      LineTo(45,375);
      LineTo(40,370);
      LineTo(60,350);
      LineTo(40,330);
      LineTo(45,325);
      SetFillStyle(1,4);
    end;
  procedure PutPreviewOfO;
    begin
      circle(65,350,25);
      circle(65,350,18);
      SetFillStyle(1,2);
    end;
  begin
    SetFillStyle(1,0);
    bar(40,325,95,390);
    SetLineStyle(0,0,1);
    SetColor(15);
    if b='x' then PutPreviewOfX else PutPreviewOfO;
    FloodFill(80,335,15);
  end;

procedure OutMessage(message:string);
  begin
    DrawBorder;
    SetTextStyle(0,0,1);
    bar(GetCenterX-(TextWidth(message)+10)div 2,GetMaxY-35,GetCenterX+
     (TextWidth(message)+7)div 2,GetMaxY-25);
    SetColor(15);
    CenterText(0,GetMaxY-33,message);
  end;

procedure PutMoveOf(d:char);
  procedure PutX;
    begin
      MoveTo(x-45,y-35);
      LineTo(x-35,y-45);
      LineTo(x,y-10);
      LineTo(x+35,y-45);
      LineTo(x+45,y-35);
      LineTo(x+10,y);
      LineTo(x+45,y+35);
      LineTo(x+35,y+45);
      LineTo(x,y+10);
      LineTo(x-35,y+45);
      LineTo(x-45,y+35);
      LineTo(x-10,y);
      LineTo(x-45,y-35);
      SetFillStyle(1,4);
    end;
  procedure PutO;
    begin
      circle(x,y,35);
      circle(x,y,45);
      SetFillStyle(1,2);
    end;
  procedure FindPlayCoords;
    begin
      case PlayOf of
        1:MoveTo(200,360);
        2:MoveTo(360,360);
        3:MoveTo(520,360);
        4:MoveTo(200,240);
        5:MoveTo(360,240);
        6:MoveTo(520,240);
        7:MoveTo(200,120);
        8:MoveTo(360,120);
        9:MoveTo(520,120);
      end;
      x:=GetX;
      y:=GetY;
    end;
  begin
    FindPlayCoords;
    SetTextStyle(0,0,1);
    SetColor(0);
    OutTextXY(x,y,'л');
    SetLineStyle(0,0,1);
    SetColor(15);
    case d of
      'x':PutX;
      'o':PutO;
    end;
    FloodFill(x+28,y+28,15);
    square[PlayOf]:=d;
  end;

procedure TestForWinOf(e:char);
var f:shortint;
  begin
    winner:=true;
    SetLineStyle(0,0,1);
    SetColor(15);
    if (square[1]=e) and (square[2]=e) and (square[3]=e) then
      Bar3D(145,359,575,361,0,TopOff)
    else if (square[1]=e) and (square[4]=e) and (square[7]=e) then
      Bar3D(199,415,201,65,0,TopOff)
    else if (square[2]=e) and (square[5]=e) and (square[8]=e) then
      Bar3D(359,415,361,65,0,TopOff)
    else if (square[3]=e) and (square[6]=e) and (square[9]=e) then
      Bar3D(519,415,521,65,0,TopOff)
    else if (square[4]=e) and (square[5]=e) and (square[6]=e) then
      Bar3D(145,239,575,241,0,TopOff)
    else if (square[7]=e) and (square[8]=e) and (square[9]=e) then
      Bar3D(145,119,575,121,0,TopOff)
    else
      begin
        SetLineStyle(0,0,3);
        if e='x' then SetColor(4) else SetColor(2);
        if (square[1]=e) and (square[5]=e) and (square[9]=e) then
          begin
            line(145,395,575,85);
            SetLineStyle(0,0,1);
            SetColor(15);
            MoveTo(574,84);
            LineTo(576,86);
            LineTo(146,396);
            LineTo(144,395);
            LineTo(574,84);
          end
        else if (square[3]=e) and (square[5]=e) and (square[7]=e) then
          begin
            line(575,395,145,85);
            SetLineStyle(0,0,1);
            SetColor(15);
            MoveTo(574,396);
            LineTo(576,394);
            LineTo(146,84);
            LineTo(144,86);
            LineTo(574,396);
          end
        else
          begin
            winner:=false;
            cat:=true;
            for f:=1 to 9 do
              if square[f]='n' then cat:=false;
          end;
      end;
  end;

procedure TestForWinScenarioFor(j:char);
  begin
    scenario:=true;
    if (square[1]=j) and (square[4]=j) and (square[7]='n') then PlayOf:=7
    else if (square[1]=j) and (square[4]='n') and (square[7]=j) then
     PlayOf:=4
    else if (square[1]='n') and (square[4]=j) and (square[7]=j) then
     PlayOf:=1
    else if (square[2]=j) and (square[5]=j) and (square[8]='n') then
     PlayOf:=8
    else if (square[2]=j) and (square[5]='n') and (square[8]=j) then
     PlayOf:=5
    else if (square[2]='n') and (square[5]=j) and (square[8]=j) then
     PlayOf:=2
    else if (square[3]=j) and (square[6]=j) and (square[9]='n') then
     PlayOf:=9
    else if (square[3]=j) and (square[6]='n') and (square[9]=j) then
     PlayOf:=6
    else if (square[3]='n') and (square[6]=j) and (square[9]=j) then
     PlayOf:=3
    else if (square[1]=j) and (square[2]=j) and (square[3]='n') then
     PlayOf:=3
    else if (square[1]=j) and (square[2]='n') and (square[3]=j) then
     PlayOf:=2
    else if (square[1]='n') and (square[2]=j) and (square[3]=j) then
     PlayOf:=1
    else if (square[4]=j) and (square[5]=j) and (square[6]='n') then
     PlayOf:=6
    else if (square[4]=j) and (square[5]='n') and (square[6]=j) then
     PlayOf:=5
    else if (square[4]='n') and (square[5]=j) and (square[6]=j) then
     PlayOf:=4
    else if (square[7]=j) and (square[8]=j) and (square[9]='n') then
     PlayOf:=9
    else if (square[7]=j) and (square[8]='n') and (square[9]=j) then
     PlayOf:=8
    else if (square[7]='n') and (square[8]=j) and (square[9]=j) then
     PlayOf:=7
    else if (square[1]=j) and (square[5]=j) and (square[9]='n') then
     PlayOf:=9
    else if (square[1]=j) and (square[5]='n') and (square[9]=j) then
     PlayOf:=5
    else if (square[1]='n') and (square[5]=j) and (square[9]=j) then
     PlayOf:=1
    else if (square[7]=j) and (square[5]=j) and (square[3]='n') then
     PlayOf:=3
    else if (square[7]=j) and (square[5]='n') and (square[3]=j) then
     PlayOf:=5
    else if (square[7]='n') and (square[5]=j) and (square[3]=j) then
     PlayOf:=7
    else scenario:=false;
  end;

procedure IncWinsOf(h:char);
  begin
    if h='x' then inc(WinsOfX) else inc(WinsOfO);
  end;

procedure PutCatIcon;
  begin
    SetFillStyle(1,0);
    bar(40,325,95,390);
    SetLineStyle(0,0,1);
    SetColor(15);
    circle(75,340,8);
    circle(75,340,15);
    SetFillStyle(1,2);
    FloodFill(87,340,15);
    SetColor(2);
    line(62,348,67,353);
    SetColor(15);
    MoveTo(40,350);
    LineTo(45,345);
    LineTo(55,355);
    LineTo(65,345);
    LineTo(70,350);
    LineTo(60,360);
    LineTo(70,370);
    LineTo(65,375);
    LineTo(55,365);
    LineTo(45,375);
    LineTo(40,370);
    LineTo(50,360);
    LineTo(40,350);
    SetFillStyle(1,4);
    FloodFill(55,360,15);
    SetTextStyle(0,0,2);
    OutlineText(65-TextWidth('Cat')div 2,345,9,15,'Cat');
    SetColor(15);
    SetTextStyle(0,0,1);
    SetColor(15);
    OutTextXY(65-TextWidth('Game') div 2,380,'Game');
  end;

procedure TwoPlayerGame;
var g:char;
  begin
    OptionOf:=1;
    if not returning then
      begin
        LastGameOf:=1;
        WinsOfX:=0;
        WinsOfO:=0;
        GamesOfCat:=0;
        FirstPlay:=true;
        TurnOf:=random(2);
        if TurnOf=1 then TurnOfX:=true else TurnOfX:=false;
      end;

    repeat
      if not returning then
        begin
          EmptySquares;

          DrawScreen;
        end;
      OutMessage('Press ''ESC'' to return to Main Menu');
      repeat
        if not returning and not winner then
          begin
            if TurnOfX then player:='x' else player:='o';
            PutPreviewOf(player);
          end
        else if winner then PutPreviewOf(player);
        if not returning and not winner then
          begin
            if FirstPlay then
              OutTextXY(65-TextWidth('Starts')div 2,380,'Starts.')
            else
              OutTextXY(65-TextWidth('Plays')div 2,380,'Plays.');
            repeat g:=ReadKey until ((g>=#49) and (g<=#57)) or (g=#27);
            if g=#27 then EscapeOut:=true;
            if not EscapeOut then
              begin
                PlayOf:=ord(g)-48;
                if square[PlayOf]='n' then
                  begin
                    PutMoveOf(player);
                    TestForWinOf(player);
                    if cat then
                      begin
                        TurnOf:=random(2);
                        if TurnOf=1 then TurnOfX:=true else TurnOfX:=false;
                      end
                    else TurnOfX:=not TurnOfX;
                    if FirstPlay then FirstPlay:=false;
                  end;
              end;
          end
        else
          begin
            TestForWinOf(player);
            if not winner and not cat then returning:=false;
          end;
      until winner or cat or EscapeOut;
      if not EscapeOut then
        begin
          if winner then
            begin
              SetFillStyle(1,0);
              bar(45,380,90,387);
              SetTextStyle(0,0,1);
              SetColor(15);
              OutTextXY(65-TextWidth('Wins')div 2,380,'Wins!');
              if not returning then IncWinsOf(player);
            end
          else
            begin
              PutCatIcon;
              if not returning then inc(GamesOfCat);
            end;
          WriteCounters;
          OutMessage('Would you like to play again? (y/n)');
          repeat PlayAgain:=UpCase(ReadKey) until (PlayAgain='Y') or
           (PlayAgain='N') or (PlayAgain=#27);
          if PlayAgain=#27 then EscapeOut:=true;
          if returning and (PlayAgain='Y') then returning:=false;
      end;
    until (PlayAgain='N') or EscapeOut;
  end;

procedure GameAgainstComputer;
var i:char;
  begin
    OptionOf:=2;
    if not returning then
      begin
        LastGameOf:=2;
        WinsOfX:=0;
        WinsOfO:=0;
        GamesOfCat:=0;
        FirstPlay:=true;
        TurnOf:=random(2);
        if TurnOf=1 then TurnOfX:=true else TurnOfX:=false;
      end;

    repeat
      if not returning then
        begin
          EmptySquares;

          DrawScreen;
        end;
      OutMessage('Press ''ESC'' to return to Main Menu');
      repeat
        if not returning then
          begin
            if TurnOfX then player:='x' else player:='o';
            PutPreviewOf(player);
          end
        else if winner then PutPreviewOf(player);
        if not returning then
          begin
            if FirstPlay then
              OutTextXY(65-TextWidth('Starts')div 2,380,'Starts.')
            else
              OutTextXY(65-TextWidth('Plays')div 2,380,'Plays.');
            if player='x' then
              begin
                TestForWinScenarioFor('x');
                if scenario then PutMoveOf('x') else
                  begin
                    TestForWinScenarioFor('o');
                    if scenario then PutMoveOf('x') else
                      begin
                        repeat PlayOf:=random(9)+1 until square[PlayOf]='n';
                        PutMoveOf('x');
                      end;
                  end;
              end
            else
              begin
                repeat
                  repeat i:=ReadKey until ((i>=#49) and (i<=#57)) or (i=#27);
                  if i=#27 then EscapeOut:=true;
                  if not EscapeOut then PlayOf:=ord(i)-48;
                until (square[PlayOf]='n') or (EscapeOut=true);
                if (square[PlayOf]='n') and not EscapeOut then PutMoveOf('o');
              end;
            if not EscapeOut then
              begin
                TestForWinOf(player);
                if not cat then TurnOfX:=not TurnOfX
                else
                  begin
                    TurnOf:=random(2);
                    if TurnOf=1 then TurnOfX:=true else TurnOfX:=false;
                  end;
                if FirstPlay then FirstPlay:=false;
              end;
          end
        else
          begin
            TestForWinOf(player);
            if not winner and not cat then returning:=false;
          end;
      until winner or cat or EscapeOut;
      if not EscapeOut then
        begin
          if winner then
            begin
              SetFillStyle(1,0);
              bar(45,380,90,387);
              SetTextStyle(0,0,1);
              SetColor(15);
              OutTextXY(65-TextWidth('Wins')div 2,380,'Wins!');
              if not returning then IncWinsOf(player);
            end
          else
            begin
              PutCatIcon;
              if not returning then inc(GamesOfCat);
            end;
          WriteCounters;
          OutMessage('Would you like to play again? (y/n)');
          repeat PlayAgain:=UpCase(ReadKey) until (PlayAgain='Y') or
           (PlayAgain='N') or (PlayAgain=#27);
          if PlayAgain=#27 then EscapeOut:=true;
          if returning and (PlayAgain='Y') then returning:=false;
      end;
    until (PlayAgain='N') or (EscapeOut);
  end;

procedure ComputerVsComputer;
var m:char;
  begin
    LastGameOf:=3;
    FirstGame:=false;
    EscapeOut:=false;

    repeat

      if not returning then
        begin
          WinsOfX:=0;
          WinsOfO:=0;
          GamesOfCat:=0;
          FirstPlay:=true;
          TurnOf:=random(2);
          if TurnOf=1 then TurnOfX:=true else TurnOfX:=false;
        end;

      repeat
        if not returning then
          begin
            EmptySquares;

            DrawScreen;
          end;
        OutMessage('Press ''ESC'' to end this madness!');
        repeat
          if not returning then
            begin
              if TurnOfX then player:='x' else player:='o';
              PutPreviewOf(player);
            end
          else if winner then PutPreviewOf(player);
          if not returning then
            begin
              if FirstPlay then
                OutTextXY(65-TextWidth('Starts')div 2,380,'Starts.')
              else
                OutTextXY(65-TextWidth('Plays')div 2,380,'Plays.');
              if player='x' then
                begin
                  TestForWinScenarioFor('x');
                  if scenario then PutMoveOf('x') else
                    begin
                      TestForWinScenarioFor('o');
                      if scenario then PutMoveOf('x') else
                        begin
                          repeat PlayOf:=random(9)+1 until square[PlayOf]='n';
                          PutMoveOf('x');
                        end;
                    end;
                end
              else
                begin
                  TestForWinScenarioFor('o');
                  if scenario then PutMoveOf('o') else
                    begin
                      TestForWinScenarioFor('x');
                      if scenario then PutMoveOf('o') else
                        begin
                          repeat PlayOf:=random(9)+1 until square[PlayOf]='n';
                          PutMoveOf('o');
                        end;
                    end;
                end;
              delay(DelayValue);
              if not EscapeOut then
                begin
                  TestForWinOf(player);
                  if not cat then TurnOfX:=not TurnOfX
                  else
                    begin
                      TurnOf:=random(2);
                      if TurnOf=1 then TurnOfX:=true else TurnOfX:=false;
                    end;
                  if FirstPlay then FirstPlay:=false;
                end;
            end
          else
            begin
              TestForWinOf(player);
              if not winner and not cat then returning:=false;
            end;
        until winner or cat or EscapeOut or KeyPressed;
        if not EscapeOut then
          begin
            if winner then
              begin
                SetFillStyle(1,0);
                bar(45,380,90,387);
                SetTextStyle(0,0,1);
                SetColor(15);
                OutTextXY(65-TextWidth('Wins')div 2,380,'Wins!');
                if not returning then IncWinsOf(player);
              end
            else
              begin
                PutCatIcon;
                if not returning then inc(GamesOfCat);
              end;
            WriteCounters;
            delay(DelayValue+DelayValue div 3);
            if (winner or cat) and returning then returning:=false;
          end;
        if KeyPressed then
          begin
            m:=ReadKey;
            if m=#27 then EscapeOut:=true;
          end;
      until EscapeOut;
    until EscapeOut;
  end;

procedure GameplayInstructions;
var k:char;
  begin
    SetFillStyle(1,0);
    SetColor(15);
    Bar3D(GetCenterX-150,GetCenterY-85,GetCenterX+150,GetCenterY+85,0,
     TopOff);
    SetTextStyle(0,0,1);
    SetColor(4);
    CenterText(-1,GetCenterY-76,'Gameplay Instructions:');
    SetColor(2);
    CenterText(0,GetCenterY-75,'Gameplay Instructions:');
    SetColor(15);
    CenterText(1,GetCenterY-74,'Gameplay Instructions:');
    SetColor(9);
    line(GetCenterX-TextWidth('Gameplay Instructions:')div 2,GetCenterY-64,
     GetCenterX+TextWidth('Gameplay Instructions')div 2,GetCenterY-64);
    SetColor(15);
    OutTextXY(GetCenterX-133,GetCenterY-53,'  Get three in a row by pressing,');
    OutTextXY(GetCenterX-133,GetCenterY-43,'on the keypad, the numbers of the');
    OutTextXY(GetCenterX-133,GetCenterY-33,'boxes in which you wish to play.');
    OutTextXY(GetCenterX-133,GetCenterY-16,'  The computer plays ''X.'' '+
     'Play a');
    OutTextXY(GetCenterX-133,GetCenterY-6,'two-player game against a friend.');
    OutTextXY(GetCenterX-133,GetCenterY+12,'  Loser always starts except in');
    OutTextXY(GetCenterX-133,GetCenterY+22,'the first game or following a '+
     'cat');
    OutTextXY(GetCenterX-133,GetCenterY+32,'game, in which cases a random');
    OutTextXY(GetCenterX-133,GetCenterY+42,'player is selected.');
    SetColor(9);
    CenterText(0,GetCenterY+60,'Press ''ENTER'' to return');
    CenterText(0,GetCenterY+70,'to Main Menu');
    repeat k:=ReadKey until (k=#13) or (k=#27);
  end;

procedure ReturnToGame;
var l:shortint;
  begin
    DrawScreen;
    for l:=1 to 9 do
      begin
        PlayOf:=l;
        if square[l]<>'n' then PutMoveOf(square[l]);
      end;
    TestForWinOf(player);
    EscapeOut:=false;
    case LastGameOf of
      1:TwoPlayerGame;
      2:GameAgainstComputer;
      3:ComputerVsComputer;
    end;
  end;

procedure MainMenu;
var choice:char;
    QuitGame:Boolean;
  procedure DrawMenuOptions;
    begin
      SetFillStyle(1,0);
      Bar(GetCenterX-120,GetCenterY-10,GetCenterX+115,GetCenterY+35);
      SetTextStyle(0,0,1);
      SetColor(15);
      CenterText(0,GetCenterY-6,'1. Play A Two-Player Game');
      CenterText(0,GetCenterY+4,'2. Play Against The Computer');
      CenterText(0,GetCenterY+14,'3. See Gameplay Instructions');
      CenterText(0,GetCenterY+24,'4. Exit Game');
    end;
  procedure DrawDialogueBox;
    begin
      SetLineStyle(0,0,1);
      SetFillStyle(1,0);
      SetColor(15);
      Bar3D(GetCenterX-150,GetCenterY-85,GetCenterX+150,GetCenterY+85,0,
       TopOff);
      SetTextStyle(0,0,3);
      SetColor(4);
      CenterText(-2,GetCenterY-76,'Tic-Tac-Toe');
      SetColor(2);
      CenterText(0,GetCenterY-74,'Tic-Tac-Toe');
      SetColor(15);
      CenterText(+2,GetCenterY-72,'Tic-Tac-Toe');
      SetTextStyle(0,0,1);
      SetColor(9);
      CenterText(0,GetCenterY-45,'by Travis Carden');
      DrawMenuOptions;
      SetColor(9);
      CenterText(0,GetCenterY+60,'Press '''+chr(27)+'Backspace'' to return');
      CenterText(0,GetCenterY+70,'to a game "in-progress"');
    end;
  procedure OnOption(a:shortint);
    begin
      SetTextStyle(0,0,1);
      SetColor(15);
      case a of
        1:HighlightText(GetCenterY-6,'1. Play A Two-Player Game');
        2:HighlightText(GetCenterY+4,'2. Play Against The Computer');
        3:HighlightText(GetCenterY+14,'3. See Gameplay Instructions');
        4:HighlightText(GetCenterY+24,'4. Exit Game');
      end;
      OptionOf:=a;
    end;
  procedure MoveCursor;
    begin
      DrawMenuOptions;
      case choice of
        #72:if OptionOf=1 then OnOption(4)
            else OnOption(OptionOf-1);
        #80:if OptionOf=4 then OnOption(1)
            else OnOption(OptionOf+1);
      end;
    end;
  begin
    repeat
      returning:=false;
      QuitGame:=false;

      DrawDialogueBox;
      OnOption(OptionOf);
      repeat
        choice:=ReadKey;
        case choice of
          #13:case OptionOf of
                1:choice:=#49;
                2:choice:=#50;
                3:choice:=#51;
                4:choice:=#52;
              end;
          #8:if not FirstGame then returning:=true;
          #27:QuitGame:=true;
        end;
        if choice=#115 then
          begin
            choice:=ReadKey;
            if choice=#116 then
              begin
                choice:=ReadKey;
                if choice=#117 then
                  begin
                    ComputerVsComputer;
                    DrawDialogueBox;
                    OnOption(OptionOf);
                  end;
              end;
          end;
        if choice=#0 then
          begin
            choice:=ReadKey;
            if (choice=#72) or (choice=#80) then MoveCursor;
          end;
      until ((choice>=#49) and (choice<=#52)) or returning or QuitGame;
      if not QuitGame then
        begin
          if not returning then
            begin
              OnOption(OptionOf);
              OptionOf:=ord(choice)-48;
              EscapeOut:=false;
              case OptionOf of
                1:TwoPlayerGame;
                2:GameAgainstComputer;
                3:GameplayInstructions;
              end;
              if OptionOf<>3 then FirstGame:=false;
            end
      else ReturnToGame;
      end;
    until (OptionOf=4) or QuitGame;
    ClearDevice;
    CloseGraph;
    halt;
  end;

begin
  InitGraphMode;
  randomize;

  OptionOf:=1;
  WinsOfX:=0;
  WinsOfO:=0;
  GamesOfCat:=0;
  FirstGame:=true;
  returning:=false;

  DrawScreen;
  MainMenu;
end.