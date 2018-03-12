package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Pulse_control_specparamContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Pulse_control_specparamContextExt extends AbstractBaseExt {

	public Pulse_control_specparamContextExt(Pulse_control_specparamContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Pulse_control_specparamContext getContext() {
		return (Pulse_control_specparamContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pulse_control_specparam());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Pulse_control_specparamContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Pulse_control_specparamContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}