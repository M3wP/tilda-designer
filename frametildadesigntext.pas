unit FrameTildaDesignText;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, FrameTildaDesignEdit;

type

	{ TTildaDesignTextFrame }

	TTildaDesignTextFrame = class(TTildaDesignEditFrame)
	private

	protected
		procedure DoValidateProp(const AProp: string; const AOldValue: string;
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

{ TTildaDesignTextFrame }

procedure TTildaDesignTextFrame.DoValidateProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	begin
	inherited DoValidateProp(AProp, AOldValue, ANewValue);
	end;

procedure TTildaDesignTextFrame.DoEditProp(const AProp: string;
		const AValue: string);
	begin
	if  CompareText(AProp, 'text') = 0 then
		TTildaText(FItem).text:= AValue
	else
		inherited DoEditProp(AProp, AValue);
	end;

procedure TTildaDesignTextFrame.DoSetItem;
	begin
	inherited;

	ValueListEditor1.Strings.Add('text=' + TTildaText(FItem).text);
	ValueListEditor1.ItemProps['text'].MaxLength:= 127;
	end;

class procedure TTildaDesignTextFrame.RegisterEditor;
	begin
	TTildaDesignClass.Create(TTildaText, Self);
	end;


initialization
	TTildaDesignTextFrame.RegisterEditor;

end.

