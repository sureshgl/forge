package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Program_nonansi_headerContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Program_nonansi_headerContextExt extends AbstractBaseExt {

	public Program_nonansi_headerContextExt(Program_nonansi_headerContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Program_nonansi_headerContext getContext() {
		return (Program_nonansi_headerContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).program_nonansi_header());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Program_nonansi_headerContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Program_nonansi_headerContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}