package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Function_subroutine_callContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Function_subroutine_callContextExt extends AbstractBaseExt {

	public Function_subroutine_callContextExt(Function_subroutine_callContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Function_subroutine_callContext getContext() {
		return (Function_subroutine_callContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).function_subroutine_call());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Function_subroutine_callContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Function_subroutine_callContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}