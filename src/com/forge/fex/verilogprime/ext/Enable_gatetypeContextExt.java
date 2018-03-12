package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Enable_gatetypeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Enable_gatetypeContextExt extends AbstractBaseExt {

	public Enable_gatetypeContextExt(Enable_gatetypeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Enable_gatetypeContext getContext() {
		return (Enable_gatetypeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).enable_gatetype());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Enable_gatetypeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Enable_gatetypeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}