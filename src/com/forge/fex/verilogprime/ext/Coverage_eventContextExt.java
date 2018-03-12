package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Coverage_eventContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Coverage_eventContextExt extends AbstractBaseExt {

	public Coverage_eventContextExt(Coverage_eventContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Coverage_eventContext getContext() {
		return (Coverage_eventContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).coverage_event());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Coverage_eventContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Coverage_eventContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}