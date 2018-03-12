package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Method_call_bodyContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Method_call_bodyContextExt extends AbstractBaseExt {

	public Method_call_bodyContextExt(Method_call_bodyContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Method_call_bodyContext getContext() {
		return (Method_call_bodyContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).method_call_body());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Method_call_bodyContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Method_call_bodyContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}