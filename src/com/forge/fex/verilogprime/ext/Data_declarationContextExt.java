package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Data_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Data_declarationContextExt extends AbstractBaseExt {

	public Data_declarationContextExt(Data_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Data_declarationContext getContext() {
		return (Data_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).data_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Data_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Data_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected Boolean isPortDeclared(String portName) {
		Data_declarationContext ctx = getContext();
		if (ctx.getText().startsWith("reg")) {
			return super.isPortDeclared(portName);
		} else {
			return false;
		}
	}
}