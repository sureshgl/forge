package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.XornContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class XornContextExt extends AbstractBaseExt {

	public XornContextExt(XornContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public XornContext getContext() {
		return (XornContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).xorn());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof XornContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + XornContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}