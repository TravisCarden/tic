{
  Author: Travis Carden
  Date: 02/16/2000
  Unit Name: stu.tpu
}

unit stu;

interface
  procedure InitGraphMode;
  function GetCenterX:integer;
  function GetCenterY:integer;
  procedure CenterText(x,y:integer;text:string);
  procedure OutlineText(x,y,ForeColor,BkColor:integer;text:string);
  procedure HighlightText(x,y,ForeColor,BkColor:integer;text:string);
  procedure center(y:integer;text:string);
  procedure nothing;


implementation
  uses crt,graph;
  procedure InitGraphMode;
    var driver,mode:integer;
    begin
      driver:=detect;
      InitGraph(driver,mode,'');
    end;
  function GetCenterX:integer;
    begin
      GetCenterX:=GetMaxX div 2;
    end;
  function GetCenterY:integer;
    begin
      GetCenterY:=GetMaxY div 2;
    end;
  procedure CenterText(x,y:integer;text:string);
    begin
      OutTextXY(GetCenterX-TextWidth(text) div 2+x,y,text);
    end;
  procedure OutlineText(x,y,ForeColor,BkColor:integer;text:string);
    begin
      SetColor(BkColor);
      OutTextXY(x-1,y,text);
      OutTextXY(x+1,y,text);
      OutTextXY(x,y-1,text);
      OutTextXY(x,y+1,text);
      SetColor(ForeColor);
      OutTextXY(x,y,text);
    end;
  procedure center(y:integer;text:string);
    begin
      GoToXY(40-length(text)div 2,y);
      write(text);
    end;
  procedure nothing;
    begin
    end;

end.