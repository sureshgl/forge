package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Cmos_switchtypeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Cmos_switchtypeContextExt extends AbstractBaseExt {

	public Cmos_switchtypeContextExt(Cmos_switchtypeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Cmos_switchtypeContext getContext() {
		return (Cmos_switchtypeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cmos_switchtype());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Cmos_switchtypeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Cmos_switchtypeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}