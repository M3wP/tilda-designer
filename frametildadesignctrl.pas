unit FrameTildaDesignCtrl;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ValEdit,
	FrameTildaDesignElem;

type

	{ TTildaDesignCtrlFrame }

	TTildaDesignCtrlFrame = class(TTildaDesignElemFrame)
	private
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

{ TTildaDesignCtrlFrame }

procedure TTildaDesignCtrlFrame.DoValidateProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	begin
	inherited DoValidateProp(AProp, AOldValue, ANewValue);
	end;

procedure TTildaDesignCtrlFrame.DoEditProp(const AProp: string;
		const AValue: string);
	begin
	inherited DoEditProp(AProp, AValue);
	end;

procedure TTildaDesignCtrlFrame.DoSetItem;
	var
	c: TTildaControl;

	begin
	inherited DoSetItem;

	c:= TTildaControl(FItem);

	ValueListEditor1.Strings.Add('text=' + IdentOrEmpty(c.text));

	ValueListEditor1.ItemProps['text'].EditStyle:= esEllipsis;
	ValueListEditor1.ItemProps['text'].ReadOnly:= True;

	ValueListEditor1.Strings.Add('textoffx=' + IntToStr(c.textoffx));

		//text: TTildaText;
		//textoffx,
		//textaccel,
		//accelchar: Byte;
	end;

class procedure TTildaDesignCtrlFrame.RegisterEditor;
	begin
	TTildaDesignClass.Create(TTildaControl, Self);
	end;


initialization
	TTildaDesignCtrlFrame.RegisterEditor;

end.

