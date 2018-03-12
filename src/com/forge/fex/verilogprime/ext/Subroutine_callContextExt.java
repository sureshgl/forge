package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Subroutine_callContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Subroutine_callContextExt extends AbstractBaseExt {

	public Subroutine_callContextExt(Subroutine_callContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Subroutine_callContext getContext() {
		return (Subroutine_callContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).subroutine_call());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Subroutine_callContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Subroutine_callContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}