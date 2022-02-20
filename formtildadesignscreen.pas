unit FormTildaDesignScreen;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

	{ TTildaDesignScreenForm }

	TTildaDesignScreenForm = class(TForm)
		PaintBox1: TPaintBox;
	private
		procedure FillRegion(const ARect: TRect; const AColour: Integer);
	public
		procedure PaintInterface;
	end;

var
	TildaDesignScreenForm: TTildaDesignScreenForm;

implementation

{$R *.lfm}

uses
	TildaDesignTypes ,TildaDesignUtils;

type
	TC64RGB = packed record
		r,
		g,
		b: Byte;
	end;

	PJudeTheme = ^TJudeTheme;
	TJudeTheme = record
		name: string;
		data: array[0..14] of Byte;
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

	ARR_REC_JUDE_THEME: array[0..5] of TJudeTheme = (
		(name:		'CORPORATE       ';
		 data:		($00, $06, $04, $01, $01, $06, $0E, $0B,
					$0F, $03, $0C, $0E, $0D, $07, $0A)),

		(name:		'DARK            ';
		 data:		($00, $00, $04, $0F, $01, $00, $0F, $0B,
					$0F, $03, $0C, $0E, $0D, $07, $0A)),

		(name:		'FAMILIAR        ';
		 data:		($00, $0E, $06, $01, $01, $0E, $04, $0C,
					$0F, $03, $0F, $06, $0D, $07, $0A)),

		(name:		'ASTRO           ';
		 data:		($00, $00, $0A, $02, $01, $00, $0A, $0B,
					$0F, $0A, $0C, $0F, $0D, $07, $0A)),

		(name:		'GREEN           ';
		 data:		($00, $05, $0D, $01, $01, $05, $0D, $0B,
					$0F, $03, $0C, $0D, $0D, $07, $0A)),

		(name:		'CORPORATE NUEVO ';
		 data:		($00, $06, $04, $01, $01, $06, $04, $0B,
					$0F, $03, $0C, $0E, $0D, $07, $0A)));

{ TTildaDesignScreenForm }

procedure TTildaDesignScreenForm.FillRegion(const ARect: TRect; const AColour: Integer);
	begin
	PaintBox1.Canvas.Brush.Color:= RGBToColor(
			ARR_REC_C64_RGB[AColour].r,ARR_REC_C64_RGB[AColour].g,
			ARR_REC_C64_RGB[AColour].b);
	PaintBox1.Canvas.Brush.Style:= bsSolid;

	PaintBox1.Canvas.FillRect(ARect);
	end;

const
	VAL_SIZ_BORDER = 30;

function CellRectToRect(const ACellSz: TPoint; const ARect: TRect): TRect;
	begin
	Result.Top:= VAL_SIZ_BORDER + ACellSz.y * ARect.Top;
	Result.Left:= VAL_SIZ_BORDER + ACellSz.x * ARect.Left;
	Result.Bottom:= VAL_SIZ_BORDER + ACellSz.y * ARect.Bottom;
	Result.Right:= VAL_SIZ_BORDER + ACellSz.x * ARect.Right;
	end;

function ControlToRect(const AX, AY, AWidth, AHeight: Byte): TRect;
	begin
	Result.Left:= AX;
	Result.Top:= AY;
	Result.Right:= AX + AWidth;
	Result.Bottom:= AY + AHeight;
	end;

function PalFromCtrlColour(const AColour: TTildaColour;
		const ATheme: PJudeTheme): Integer;
	var
	domain: TTildaColourDomain;
	val: Byte;

	begin
	domain:= TTildaColourDomain(Word(AColour) shr 8);
	val:= Word(AColour) and $FF;

	if  domain = tcdTheme then
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

procedure TTildaDesignScreenForm.PaintInterface;
	var
	cellsz: TPoint;
	theme: PJudeTheme;
	ui: TTildaUInterface;
	vw: TTildaView;
	i: Integer;

	begin
	theme:= @ARR_REC_JUDE_THEME[0];

	FillRegion(Rect(0, 0, 700, 460), theme^.Data[Ord(tckEmpty)]);

	ui:= FirstByClass(TTildaUInterface) as TTildaUInterface;
	vw:= ui.views[0];

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
			FillRegion(CellRectToRect(cellsz, ControlToRect(
				vw.actvpage.panels[i].posx,
				vw.actvpage.panels[i].posy,
				vw.actvpage.panels[i].width,
				vw.actvpage.panels[i].height)),
				PalFromCtrlColour(vw.actvpage.panels[i].colour, theme));
		end;
	end;

end.

