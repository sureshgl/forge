package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Generate_regionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Generate_regionContextExt extends AbstractBaseExt {

	public Generate_regionContextExt(Generate_regionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Generate_regionContext getContext() {
		return (Generate_regionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).generate_region());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Generate_regionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Generate_regionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}