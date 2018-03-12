package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Coverage_specContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Coverage_specContextExt extends AbstractBaseExt {

	public Coverage_specContextExt(Coverage_specContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Coverage_specContext getContext() {
		return (Coverage_specContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).coverage_spec());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Coverage_specContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Coverage_specContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}