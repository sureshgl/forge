package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Net_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Net_declarationContextExt extends AbstractBaseExt {

	public Net_declarationContextExt(Net_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Net_declarationContext getContext() {
		return (Net_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).net_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Net_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Net_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected Boolean isPortDeclared(String portName) {
		Net_declarationContext ctx = getContext();
		if (ctx.getText().startsWith("wire")) {
			return super.isPortDeclared(portName);
		} else {
			return false;
		}
	}
}