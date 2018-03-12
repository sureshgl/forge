package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Sequence_actual_argContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Sequence_actual_argContextExt extends AbstractBaseExt {

	public Sequence_actual_argContextExt(Sequence_actual_argContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Sequence_actual_argContext getContext() {
		return (Sequence_actual_argContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).sequence_actual_arg());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Sequence_actual_argContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Sequence_actual_argContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}