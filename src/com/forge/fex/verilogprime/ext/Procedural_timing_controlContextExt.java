package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Procedural_timing_controlContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Procedural_timing_controlContextExt extends AbstractBaseExt {

	public Procedural_timing_controlContextExt(Procedural_timing_controlContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Procedural_timing_controlContext getContext() {
		return (Procedural_timing_controlContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).procedural_timing_control());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Procedural_timing_controlContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Procedural_timing_controlContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}