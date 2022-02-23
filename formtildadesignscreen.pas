unit FormTildaDesignScreen;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
	TildaDesignTypes;

type
	PJudeTheme = ^TJudeTheme;
	TJudeTheme = record
		name: string;
		data: array[0..14] of Byte;
	end;

const
	ARR_REC_JUDE_THEME: array[0..5] of TJudeTheme = (
		(name:		'CORPORATE       ';
		 data:		($00, $06, $04, $01, $01, $06, $0E, $0B,
					$0F, $03, $0C, $0E, $0D, $07, $0A)),

		(name:		'DARK            ';
		 data:		($00, $00, $04, $0F, $01, $00, $0E, $0B,
					$0F, $03, $0C, $0E, $0D, $07, $0A)),

		(name:		'FAMILIAR        ';
		 data:		($00, $0E, $06, $01, $01, $0E, $04, $0C,
					$0F, $03, $0F, $06, $0D, $07, $0A)),

		(name:		'ASTRO           ';
		 data:		($00, $00, $0A, $02, $01, $00, $0A, $0B,
					$0F, $0A, $0C, $0F, $0D, $07, $0A)),

			//'CLR_BACK', 'CLR_EMPTY', 'CLR_CURSOR', 'CLR_TEXT',
			//'CLR_FOCUS', 'CLR_INSET', 'CLR_FACE', 'CLR_SHADOW' ,
			//'CLR_PAPER', 'CLR_MONEY' ,'CLR_ITEM' ,'CLR_INFORM' ,
			//'CLR_ACCEPT', 'CLR_APPLY', 'CLR_ABORT');

		(name:		'GREENS          ';
		 data:		($0D, $00, $05, $0D, $01, $00, $05, $0B,
					$0F, $03, $0C, $0E, $0D, $07, $0A)),
//		 data:		($00, $05, $0D, $01, $01, $05, $0D, $0B,
//					$0F, $03, $0C, $0D, $0D, $07, $0A)),

		(name:		'NUEVO           ';
		 data:		($01, $06, $04, $00, $01, $06, $04, $0B,
					$0F, $03, $0C, $0E, $0D, $07, $0A)));

type
	{ TTildaDesignScreenForm }

	TTildaDesignScreenForm = class(TForm)
		img40x25: TImage;
		img80x50: TImage;
		img40x50: TImage;
		img80x25: TImage;
		PaintBox1: TPaintBox;
	private
		procedure FillRegion(const ARect: TRect; const AColour: Integer);
		procedure TextOut(const AText: AnsiString; const ACRect: TRect;
				const AIndent, AOffs: Byte; const ACellSz: TPoint;
				AColour: Integer);
	public
		procedure PaintInterface(const ASelected: TTildaAbstract;
			const ATheme: Integer);
	end;

var
	TildaDesignScreenForm: TTildaDesignScreenForm;

implementation

{$R *.lfm}

uses
	BGRABitmap, BGRABitmapTypes, TildaDesignUtils;

type
	TC64RGB = packed record
		r,
		g,
		b: Byte;
	end;


const
	ARR_REC_C64_RGB: array[0..15] of TC64RGB = (
			(r: $00; g: $00; b: $00),
			(r: $F0; g: $F0; b: $F0),
			(r: $F0; g: $00; b: $00),
			(r: $00; g: $F0; b: $F0),
			(r: $F0; g: $00; b: $F0),
			(r: $00; g: $F0; b: $00),
			(r: $00; g: $00; b: $F0),
			(r: $F0; g: $F0; b: $00),
			(r: $F0; g: $60; b: $00),
			(r: $A0; g: $40; b: $00),
			(r: $F0; g: $70; b: $70),
			(r: $50; g: $50; b: $50),
			(r: $80; g: $80; b: $80),
			(r: $90; g: $F0; b: $90),
			(r: $90; g: $90; b: $F0),
			(r: $B0; g: $B0; b: $B0));


const
	VAL_SIZ_BORDER = 30;

function CellRectToRect(const ACellSz: TPoint; const ARect: TRect): TRect;
	begin
	Result.Top:= VAL_SIZ_BORDER + ACellSz.y * ARect.Top;
	Result.Left:= VAL_SIZ_BORDER + ACellSz.x * ARect.Left;
	Result.Bottom:= VAL_SIZ_BORDER + ACellSz.y * ARect.Bottom;
	Result.Right:= VAL_SIZ_BORDER + ACellSz.x * ARect.Right;

//	Result.Bottom:= Result.Top + ACellSz.y * ARect.Bottom;
//	Result.Right:= Result.Left + ACellSz.x * ARect.Right;

	end;


{ TTildaDesignScreenForm }

procedure TTildaDesignScreenForm.FillRegion(const ARect: TRect; const AColour: Integer);
	begin
	PaintBox1.Canvas.Brush.Color:= RGBToColor(
			ARR_REC_C64_RGB[AColour].r,ARR_REC_C64_RGB[AColour].g,
			ARR_REC_C64_RGB[AColour].b);
	PaintBox1.Canvas.Brush.Style:= bsSolid;

	PaintBox1.Canvas.FillRect(ARect);
	end;

procedure TTildaDesignScreenForm.TextOut(const AText: AnsiString;
		const ACRect: TRect; const AIndent, AOffs: Byte;
		const ACellSz: TPoint; AColour: Integer);

	var
	s: AnsiString;
	clr: TColor;
	isrc: TImage;
//	src,
//	tex
	msk: TBGRABitmap;
	i: Integer;
	x: Integer;
	d,
	r: TRect;

	function ImageSrcForCellSz(ACellSz: TPoint): TImage;
		begin
		Result:= nil;

		case ACellSz.X of
			8:
				case ACellSz.Y of
					8:
						Result:= img80x50;
					16:
						Result:= img80x25;
				end;
			16:
				case ACellSz.Y of
					8:
						Result:= img40x50;
					16:
						Result:= img40x25;
				end;
			end;
		end;

	begin
	s:= Copy(AText, AIndent + 1, ACRect.Right - ACRect.Left);
	clr:= RGBToColor(
			ARR_REC_C64_RGB[AColour].r,ARR_REC_C64_RGB[AColour].g,
			ARR_REC_C64_RGB[AColour].b);

	isrc:= ImageSrcForCellSz(ACellSz);
	msk:= TBGRABitmap.Create(Length(s) * ACellSz.X, ACellSz.Y, BGRAPixelTransparent);

	r.Top:= 0;
	r.Bottom:= ACellSz.Y;

	d.Top:= 0;
	d.Bottom:= ACellSz.Y;

	x:= 0;
	for i:= Low(s) to High(s) do
		begin
		r.Left:= (Ord(s[i]) - $20) * ACellSz.X;
		r.Right:= r.Left + ACellSz.X;

		d.Left:= x;
		d.Right:= x + ACellSz.X;

//		msk.CanvasBGRA.CopyRect(d, src, r);
		msk.Canvas.CopyRect(d, isrc.Picture.PNG.Canvas, r);

//		PaintBox1.Canvas.CopyRect(Rect(x, 0, x + 8, 16), src.Canvas, r);;

		Inc(x, ACellSz.X);
		end;

//	msk.Draw(PaintBox1.Canvas, 100, 100, False);

	r:= CellRectToRect(ACellSz, Rect(ACRect.Left + AOffs, ACRect.Top,
		ACRect.Right + AOffs, ACRect.Bottom));

	msk.ReplaceColor(clWhite, clr);
	msk.Draw(PaintBox1.Canvas, r.Left, r.Top, False);

//	tex.Free;
	msk.Free;
	end;


function ControlToRect(const AX, AY, AWidth, AHeight: Byte): TRect;
	begin
	Result.Left:= AX;
	Result.Top:= AY;
	Result.Right:= AX + AWidth;
	Result.Bottom:= AY + AHeight;
	end;

function PalFromCtrlColour(const AColour: TTildaColour;
		const ATheme: PJudeTheme; const AText: Boolean = False): Integer;
	var
	domain: TTildaColourDomain;
	val: Byte;

	begin
	domain:= TTildaColourDomain(Word(AColour) shr 8);
	val:= Word(AColour) and $FF;

	if  AText then
		begin
		if  val <> Ord(tckText) then
			Result:= Ord(ATheme^.data[Ord(tckBack)])
		else
			Result:= Ord(ATheme^.data[Ord(tckText)]);
		end
	else if  domain = tcdTheme then
		if  val = Ord(tckText) then
			Result:= Ord(ATheme^.data[Ord(tckBack)])
		else
			Result:= ATheme^.data[val]
	else
		if  domain = tcdSysText then
			Result:= Ord(ATheme^.data[Ord(tckBack)])
		else
			Result:= ATheme^.data[val];
	end;

procedure TTildaDesignScreenForm.PaintInterface(
			const ASelected: TTildaAbstract; const ATheme: Integer);
	var
	cellsz: TPoint;
	theme: PJudeTheme;
	ui: TTildaUInterface;
	vw: TTildaView;
	i,
	j: Integer;
	pt: TPoint;
	c: Integer;

	procedure DrawFocusRect(AFocus: TTildaAbstract);
		var
		r: TRect;
		pt: TPoint;

		begin
		if  Assigned(AFocus) then
			begin
			if  AFocus is TTildaPoint then
				begin
				PaintBox1.Canvas.Pen.Color:= clLime;

				r:= CellRectToRect(cellsz, ControlToRect(
						TTildaPoint(AFocus).x,
						TTildaPoint(AFocus).y, 1, 1));
				end
			else if  AFocus is TTildaElement then
				begin
				PaintBox1.Canvas.Pen.Color:= clRed;

				if  Assigned(TTildaElement(AFocus).ptoffs) then
					begin
					pt.x:= TTildaElement(AFocus).ptoffs.x;
					pt.y:= TTildaElement(AFocus).ptoffs.y
					end
				else
					begin
					pt.x:= 0;
					pt.y:= 0;
					end;

				r:= CellRectToRect(cellsz, ControlToRect(
						TTildaElement(AFocus).posx + pt.x,
						TTildaElement(AFocus).posy + pt.y,
						TTildaElement(AFocus).width,
						TTildaElement(AFocus).height));
				end
			else
				Exit;

			r.Inflate(1, 1, 1, 1);

			PaintBox1.Canvas.Brush.Style:= bsClear;
			PaintBox1.Canvas.Pen.Style:= psSolid;
			PaintBox1.Canvas.Pen.Width:= 2;

			PaintBox1.Canvas.Rectangle(r);
			end;
		end;

	begin
	theme:= @ARR_REC_JUDE_THEME[ATheme];

	FillRegion(Rect(0, 0, 700, 460), theme^.Data[Ord(tckEmpty)]);

	ui:= FirstByClass(TTildaUInterface) as TTildaUInterface;
	if  not Assigned(ui) then
		Exit;

	vw:= ui.views[0];
	if  not Assigned(vw) then
		Exit;

	if  vw.width = 80 then
		cellsz.x:= 8
	else
		cellsz.x:= 16;

	if  vw.height = 50 then
		cellsz.y:= 8
	else
		cellsz.y:= 16;

	if  Assigned(vw.actvpage) then
		begin
		FillRegion(CellRectToRect(cellsz, ControlToRect(vw.actvpage.posx,
				vw.actvpage.posy, vw.actvpage.width, vw.actvpage.height)),
				PalFromCtrlColour(vw.actvpage.colour, theme));

		for i:= 0 to vw.actvpage.panels.Count - 1 do
			begin
			if  Assigned(vw.actvpage.panels[i].ptoffs) then
				begin
				pt.x:= vw.actvpage.panels[i].ptoffs.x;
				pt.y:= vw.actvpage.panels[i].ptoffs.y
				end
			else
				begin
				pt.x:= 0;
				pt.y:= 0;
				end;

			FillRegion(CellRectToRect(cellsz, ControlToRect(
				vw.actvpage.panels[i].posx + pt.x,
				vw.actvpage.panels[i].posy + pt.y,
				vw.actvpage.panels[i].width,
				vw.actvpage.panels[i].height)),
				PalFromCtrlColour(vw.actvpage.panels[i].colour, theme));

			for j:= 0 to vw.actvpage.panels[i].controls.Count - 1 do
				begin
				if  Assigned(vw.actvpage.panels[i].controls[j].ptoffs) then
					begin
					pt.x:= vw.actvpage.panels[i].controls[j].ptoffs.x;
					pt.y:= vw.actvpage.panels[i].controls[j].ptoffs.y
					end
				else
					begin
					pt.x:= 0;
					pt.y:= 0;
					end;

				FillRegion(CellRectToRect(cellsz, ControlToRect(
					vw.actvpage.panels[i].controls[j].posx + pt.x,
					vw.actvpage.panels[i].controls[j].posy + pt.y,
					vw.actvpage.panels[i].controls[j].width,
					vw.actvpage.panels[i].controls[j].height)),
					PalFromCtrlColour(vw.actvpage.panels[i].controls[j].colour,
					theme));

				if  Assigned(vw.actvpage.panels[i].controls[j].text) then
					begin
					TextOut(vw.actvpage.panels[i].controls[j].text.text,
							ControlToRect(
							vw.actvpage.panels[i].controls[j].posx + pt.x,
							vw.actvpage.panels[i].controls[j].posy + pt.y,
							vw.actvpage.panels[i].controls[j].width,
							vw.actvpage.panels[i].controls[j].height),
							0,
							vw.actvpage.panels[i].controls[j].textoffx,
							cellsz, PalFromCtrlColour(
							vw.actvpage.panels[i].controls[j].colour, theme, True));
					end;
				end;
			end;
		end;

	DrawFocusRect(ASelected);

	if  (ASelected is TTildaElement)
	and Assigned(TTildaElement(ASelected).ptoffs) then
		DrawFocusRect(TTildaElement(ASelected).ptoffs);

//	TextOut('T E S T I N G !', ControlToRect(20, 10, 20, 1), 0, 0, cellsz,
//			PalFromCtrlColour(Ord(tckBack), theme));
	end;

end.

