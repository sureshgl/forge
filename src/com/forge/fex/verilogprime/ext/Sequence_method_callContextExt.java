package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Sequence_method_callContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Sequence_method_callContextExt extends AbstractBaseExt {

	public Sequence_method_callContextExt(Sequence_method_callContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Sequence_method_callContext getContext() {
		return (Sequence_method_callContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).sequence_method_call());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Sequence_method_callContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Sequence_method_callContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}