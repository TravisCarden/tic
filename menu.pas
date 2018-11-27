unit menu;

interface
  procedure InitMenu;
  procedure SetMenuColors(color1,color2:shortint);
  procedure SetMenuXY(x,y:integer);
  procedure RefreshScreen;
  procedure DialogBox(width,height:integer;title:string);
  procedure HighlightText(y:integer;text:string);

implementation
  uses crt,graph,stu;
  var TitleBarColor,WallpaperColor:1..15;
      MenuX,MenuY:integer;
      XYReset:Boolean;
  procedure InitMenu;
    begin
      XYReset:=false;
      WallpaperColor:=1;
      TitleBarColor:=9;
    end;
  procedure SetMenuColors(color1,color2:shortint);
    begin
      WallpaperColor:=color1;
      TitleBarColor:=color2;
    end;
  procedure SetMenuXY(x,y:integer);
    begin
      MenuX:=x;
      MenuY:=y;
      XYReset:=true;
    end;
  procedure RefreshScreen;
    begin
      SetLineStyle(0,0,3);
      SetFillStyle(11,WallpaperColor);
      SetColor(8);
      Bar3D(5,5,GetMaxX-5,GetMaxY-5,0,TopOff);
    end;
  procedure DialogBox(width,height:integer;title:string);
  var x,y,xVar,yVar:integer;
    begin
      if XYReset then
        begin
          x:=MenuX;
          y:=MenuY;
        end
      else
        begin
          x:=GetCenterX;
          y:=GetCenterY;
        end;
      xVar:=width div 2;
      yVar:=height div 2;
      SetLineStyle(0,0,3);
      SetFillStyle(1,0);
      SetColor(15);
      Bar3D(x-xVar,y-yVar,x+xVar,y+yVar,
       0,TopOff);
      SetFillStyle(9,TitleBarColor);
      Bar3D(x-xVar,y-yVar,x+xVar,y-yVar+
       20,0,TopOff);
      SetTextStyle(0,0,1);
      OutTextXY(x-xVar+10,y-yVar+7,title);
      XYReset:=false;
    end;
  procedure HighlightText(y:integer;text:string);
  var a:shortint;
    begin
      SetColor(15);
      for a:=0 to length(text) do
        begin
          OutTextXY(GetCenterX-TextWidth('Û')*(length(text)+1)div 2+
           TextWidth('Û')*a,y,'Û');
        end;
      SetColor(0);
      CenterText(0,y,text);
    end;
end.