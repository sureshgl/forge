package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.AttheratestarContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class AttheratestarContextExt extends AbstractBaseExt {

	public AttheratestarContextExt(AttheratestarContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public AttheratestarContext getContext() {
		return (AttheratestarContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).attheratestar());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof AttheratestarContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + AttheratestarContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}