package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Sequence_instanceContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Sequence_instanceContextExt extends AbstractBaseExt {

	public Sequence_instanceContextExt(Sequence_instanceContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Sequence_instanceContext getContext() {
		return (Sequence_instanceContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).sequence_instance());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Sequence_instanceContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Sequence_instanceContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}