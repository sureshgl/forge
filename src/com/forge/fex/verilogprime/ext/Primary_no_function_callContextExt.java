package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Primary_no_function_callContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Primary_no_function_callContextExt extends AbstractBaseExt {

	public Primary_no_function_callContextExt(Primary_no_function_callContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Primary_no_function_callContext getContext() {
		return (Primary_no_function_callContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).primary_no_function_call());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Primary_no_function_callContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Primary_no_function_callContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}