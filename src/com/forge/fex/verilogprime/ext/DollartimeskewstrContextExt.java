package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollartimeskewstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollartimeskewstrContextExt extends AbstractBaseExt {

	public DollartimeskewstrContextExt(DollartimeskewstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollartimeskewstrContext getContext() {
		return (DollartimeskewstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollartimeskewstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollartimeskewstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ DollartimeskewstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}