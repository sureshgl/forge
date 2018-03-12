package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EndinterfacestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EndinterfacestrContextExt extends AbstractBaseExt {

	public EndinterfacestrContextExt(EndinterfacestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EndinterfacestrContext getContext() {
		return (EndinterfacestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).endinterfacestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EndinterfacestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ EndinterfacestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}