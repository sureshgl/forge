package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Cmos_switch_instanceContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Cmos_switch_instanceContextExt extends AbstractBaseExt {

	public Cmos_switch_instanceContextExt(Cmos_switch_instanceContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Cmos_switch_instanceContext getContext() {
		return (Cmos_switch_instanceContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cmos_switch_instance());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Cmos_switch_instanceContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Cmos_switch_instanceContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}