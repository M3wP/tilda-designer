unit FrameTildaDesignPoint;

{$mode Delphi}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, FrameTildaDesignEdit;

type

	{ TTildaDesignPointFrame }

 TTildaDesignPointFrame = class(TTildaDesignEditFrame)
	private

	protected
		procedure DoValidateProp(const AProp: string; const AOldValue: string;
			var ANewValue: string); override;
		procedure DoLookupProp(const AProp: string; const AOldValue: string;
			var ANewValue: string); override;
		procedure DoEditProp(const AProp: string; const AValue: string); override;

		procedure DoSetItem; override;

	public
		class procedure RegisterEditor; override;

	end;

implementation

{$R *.lfm}

uses
	TildaDesignTypes, TildaDesignClasses;

{ TTildaDesignPointFrame }

procedure TTildaDesignPointFrame.DoValidateProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	var
	v: Integer;

	begin
	if  (CompareText(AProp, 'x') = 0)
	or  (CompareText(AProp, 'y') = 0) then
		begin
		if  not TryStrToInt(ANewValue, v) then
			ANewValue:= AOldValue;
		end
	else
		inherited;
	end;

procedure TTildaDesignPointFrame.DoLookupProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	begin
	inherited;
	end;

procedure TTildaDesignPointFrame.DoEditProp(const AProp: string;
		const AValue: string);
	begin
	if  CompareText(AProp, 'x') = 0 then
		TTildaPoint(FItem).x:= StrToInt(AValue)
	else if  CompareText(AProp, 'y') = 0 then
		TTildaPoint(FItem).y:= StrToInt(AValue)
	else
		inherited;
	end;

procedure TTildaDesignPointFrame.DoSetItem;
	begin
	inherited;

	ValueListEditor1.Strings.Add('x=' + IntToStr(TTildaPoint(FItem).x));
	ValueListEditor1.Strings.Add('y=' + IntToStr(TTildaPoint(FItem).y));
	end;

class procedure TTildaDesignPointFrame.RegisterEditor;
	begin
	TTildaDesignClass.Create(TTildaPoint, Self);
	end;


initialization
	TTildaDesignPointFrame.RegisterEditor;

end.

