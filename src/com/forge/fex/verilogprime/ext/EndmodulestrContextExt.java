package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EndmodulestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EndmodulestrContextExt extends AbstractBaseExt {

	public EndmodulestrContextExt(EndmodulestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EndmodulestrContext getContext() {
		return (EndmodulestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).endmodulestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EndmodulestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + EndmodulestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}