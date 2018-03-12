package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Method_callContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Method_callContextExt extends AbstractBaseExt {

	public Method_callContextExt(Method_callContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Method_callContext getContext() {
		return (Method_callContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).method_call());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Method_callContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Method_callContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}